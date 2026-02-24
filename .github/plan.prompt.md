# Plan prompt template

Purpose:
1. Do not execute any code changes unless explicitly instructed by the instructions "implement the plan".
2. Provide a clear, reusable prompt that an automated agent or developer can use to generate an implementation plan or step-by-step instructions for a coding task.
3. Always write the output to a markdown file in the plans directory.
4. The output filename stored in the plans directory is auto-generated from the task description unless an explicit filename is provided.


Input (what the agent receives):
- task: A short description of the feature or fix (one sentence). Example: "Add solid walls to the snake game".
- scope: Files or modules to modify (default: workspace; use `{{file_list}}`).
- constraints: Any technical constraints (dependencies, language, performance, API limits).
- tests: If applicable, list tests to pass or how to validate the change.

Constraints and rules (hard requirements):
- Language for code and comments: English.
- User-facing messages (UI/errors): French.
- Keep functions small (prefer <50 lines); follow SRP.
- Remove unused imports and debug prints.
- Add English docstrings to modified/added functions.
- Do not include secrets or credentials.
- If changes are non-trivial, ask the maintainer before proceeding.

Output format (strict):
Return a markdown document containing these sections exactly in this order:

1. Summary
   - 1-2 sentences describing what will be implemented.
2. Files to change
   - Bullet list of file paths that will be edited/created.
3. High-level plan
   - 3-6 bullet steps describing the implementation approach.
4. Small tasks (detailed)
   - Numbered list of concrete, small, testable tasks (one feature per task).
5. Example code snippets (if needed)
   - Minimal examples showing API usage or key algorithm.
6. Validation / Acceptance Criteria
   - Clear checks that can be performed by the user (manual steps or tests).
7. Notes / Questions
   - Any assumptions, open questions, or risks.

Usage
- Keep the task description concise and include any example input/output if relevant.

# Short checklist to include in commit/PR description
- [ ] Removed unused imports and dead code
- [ ] Added/verified English docstrings for modified functions
- [ ] Kept user-facing messages in French unchanged or improved in French
- [ ] Ran formatter/linter or declared they were not run
- [ ] Ensured change is a single, focused feature (one feature per commit)
