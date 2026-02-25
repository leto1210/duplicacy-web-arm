#!/usr/bin/env bash
set -euo pipefail

child=0
usrId="${USR_ID:-0}"
grpId="${GRP_ID:-0}"

# terminator: Handle termination signals for the child process.
# Params: none.
# Returns: none.
# Errors: none.
terminator() {
  echo
  if [ "${child:-0}" -ne 0 ]; then
    echo "Arrêt du processus ${child}..."
    kill -TERM "$child" 2>/dev/null || true
  fi
  echo "Fermeture."
}

trap terminator SIGHUP SIGINT SIGQUIT SIGTERM

# log_user_context: Log the effective user and group.
# Params: none.
# Returns: none.
# Errors: none.
log_user_context() {
  local userName groupName userId groupId
  userName="$(id -un)"
  groupName="$(id -gn)"
  userId="$(id -u)"
  groupId="$(id -g)"
  echo "launch.sh en cours d'exécution en tant que ${userName}:${groupName} (${userId}:${groupId})"
}

# reset_userbase: Reset /etc/passwd and /etc/group to minimal entries.
# Params: none.
# Returns: none.
# Errors: exits on write failure.
reset_userbase() {
  echo "root:x:0:root" > /etc/group
  echo "root:x:0:0:root:/root:/bin/ash" > /etc/passwd
}

# ensure_user_group: Create user/group when IDs are non-zero.
# Params: none.
# Returns: none.
# Errors: exits on adduser/addgroup failure.
ensure_user_group() {
  if [ "$grpId" -ne 0 ]; then
    addgroup -g "$grpId" -S duplicacy
  fi
  if [ "$usrId" -ne 0 ]; then
    adduser -u "$usrId" -S duplicacy -G duplicacy
  fi
}

# ensure_directories: Create required directories and set ownership.
# Params: none.
# Returns: none.
# Errors: exits on mkdir/chown failure.
ensure_directories() {
  mkdir -p /config /logs /cache
  chown -R "$usrId:$grpId" /config /logs /cache
}

# ensure_machine_id: Ensure a valid persistent machine ID exists.
# Params: none.
# Returns: none.
# Errors: exits on dbus-uuidgen failure.
ensure_machine_id() {
  if ! dbus-uuidgen --ensure=/config/machine-id; then
    echo "machine-id invalide, régénération."
    dbus-uuidgen > /config/machine-id
  fi
  echo "machine-id utilisé = $(cat /var/lib/dbus/machine-id)"
}

# start_child: Start launch.sh as the target user.
# Params: none.
# Returns: none.
# Errors: exits on su-exec failure.
start_child() {
  su-exec "$usrId:$grpId" launch.sh &
  child=$!
  wait "$child"
}

log_user_context
reset_userbase
ensure_user_group
ensure_directories
ensure_machine_id
start_child