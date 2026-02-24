# Copilot / AI Agent Instructions (Actionable)

Before editing (must perform for every prompt that will change code)
- Run these checks and apply fixes where possible:
  1. Remove unused imports and dead code (e.g., `import sys` if unused).
  2. Remove commented-out code and debug prints (`print`/`console.log`).
  3. Ensure every function has an English comment describing: purpose, parameters, return value and exceptions.
  4. Keep user-facing messages (UI text, user visible errors, notifications) in French only.
  5. Follow naming conventions: variables/functions (camelCase), classes (PascalCase), constants (UPPER_SNAKE_CASE).
  6. Keep functions reasonably short (prefer <50 lines); if a function grows, split responsibilities (SRP).
  7. Verify if libraries are already installed before asking to add new dependencies.

Coding standards (apply automatically)
- Language: code and comments in English. UI / messages to users in French.
- Clean code: no duplicated code, no dead variables, no unused imports.
- Composition preferred over inheritance; prefer small composable functions.
- Simplicity: choose functions over classes when state is not required.

Checklist to include in commit/PR description (copy these items)
- [ ] Removed unused imports and dead code
- [ ] Added/verified English docstrings for modified functions
- [ ] Kept user-facing messages in French unchanged or improved in French
- [ ] Ran formatter/linter or declared they were not run
- [ ] Ensured change is a single, focused feature (one feature per commit)

Design principles (short)
- SRP: each function/class should have one reason to change.
- KISS: prefer the simplest solution that satisfies requirements.
- Prefer composition: assemble behavior from small units rather than deep inheritance hierarchies.

Specials rules
- For *.py files follow instructions in python.instructions.md.

If uncertain or rules conflict
- Do not make guesses that could break project conventions.
- Ask the maintainer with a short question referencing the rule conflict before changing code.

Final note
- If you want stricter enforcement, add CI or pre-commit hooks; ask the maintainer first.