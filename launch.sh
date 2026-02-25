#!/usr/bin/env bash
set -euo pipefail

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
  echo "duplicacy_web en cours d'exécution en tant que ${userName}:${groupName} (${userId}:${groupId})"
}

# ensure_config_symlink: Ensure the config symlink exists.
# Params: none.
# Returns: none.
# Errors: exits on failure to create symlink.
ensure_config_symlink() {
  if [ ! -d "$HOME/.duplicacy-web" ]; then
    ln -s /config "$HOME/.duplicacy-web"
  fi
}

# ensure_log_file: Ensure the log file exists.
# Params: none.
# Returns: none.
# Errors: exits on failure to create the file.
ensure_log_file() {
  touch /logs/duplicacy_web.log
}

# write_default_settings: Create default settings if missing.
# Params: none.
# Returns: none.
# Errors: exits on failure to write file.
write_default_settings() {
  if [ ! -f /config/settings.json ]; then
    cat > /config/settings.json <<'EOF'
{
  "listening_address": "0.0.0.0:3875",
  "log_directory": "/logs",
  "temporary_directory": "/cache"
}
EOF
  fi
}

# write_default_duplicacy_config: Create default duplicacy config if missing.
# Params: none.
# Returns: none.
# Errors: exits on failure to write file.
write_default_duplicacy_config() {
  if [ ! -f /config/duplicacy.json ]; then
    echo '{}' > /config/duplicacy.json
  fi
}

# start_log_tail: Tail the log file in background.
# Params: none.
# Returns: none.
# Errors: none.
start_log_tail() {
  echo "Suivi du journal à partir de maintenant"
  tail -n 0 -F /logs/duplicacy_web.log &
}

# start_duplicacy_web: Start the service.
# Params: none.
# Returns: none.
# Errors: exits if duplicacy_web fails.
start_duplicacy_web() {
  echo "Démarrage de duplicacy"
  exec duplicacy_web
}

log_user_context
ensure_config_symlink
ensure_log_file
write_default_settings
write_default_duplicacy_config
start_log_tail
start_duplicacy_web
