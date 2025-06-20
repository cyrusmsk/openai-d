# AGENTS.md

## 1. Project Overview

* Repository: `https://github.com/lempiji/openai-d`
* Name: openai-d
* Description: An unofficial OpenAI API client library for the D programming language, supporting the Azure OpenAI Service.
* Installation: Published on Dub registry; install via `dub add openai-d`
* Language: D (100%)
* License: MIT

## 2. Development Setup

* Ensure `dmd` and `dub` are available using the stable installer script (`/workspace/dlang/install.sh`).

## 3. Testing

* Run all tests:

  ```bash
  dub test
  ```
* Guidelines:

  * Use `unittest` blocks; add tests for private methods when behavior is unclear.
  * After any code change, verify tests pass before committing.

## 4. Coverage Report

* Generate coverage data:

  ```bash
  dub test --coverage --coverage-ctfe
  ```
* Check results: Inspect the last two lines of each `source-openai-*.lst` file in the project root for coverage percentages.

## 5. Formatter

* Before running `dub run dfmt`, ensure the formatter is installed. One-line
  installation command:

  ```bash
  dub fetch dfmt && dub run dfmt -- --version
  ```
  Network access or a setup script is required for this step.
* **Run dfmt immediately before committing and never alter its output by hand.**

* Library source:

  ```bash
  dub run dfmt -- source
  ```
* Examples folder:

  ```bash
  dub run dfmt -- examples
  ```

* CI runs dfmt on `source` and `examples` and fails if `git diff --exit-code` detects changes.
* **Never edit dfmt output manually. Commit formatting changes exactly as produced.**

## 6. Linter

* Run linter:

  ```bash
  dub lint --dscanner-config dscanner.ini
  ```

## 7. Development Workflow

1. Modify code.
2. Run formatter and linter
3. Run tests and coverage
4. Build examples

   1. If you’ve modified any example group (e.g. `chat`, `audio`, `administration`), build **core** plus those groups:

      ```bash
       rdmd scripts/build_examples.d core <modified-group>[ <another-group> …]
      ```

      * Example: you fixed something in the administration examples

        ```bash
         rdmd scripts/build_examples.d core administration
        ```
   2. If you haven’t touched any example-specific code, just run **core** (always required):

      ```bash
       rdmd scripts/build_examples.d core
      ```
      * `core` intentionally skips directories containing underscores. Use the
        `all` mode to build them manually. For example, to build the
        `administration_invites` examples:

        ```bash
         rdmd scripts/build_examples.d all administration_invites
        ```
   3. To mirror CI or prepare a full release, you can still build **all**:

      ```bash
      rdmd scripts/build_examples.d all
      ```
   4. To remove `dub.selections.json` and build artifacts after compiling, pass
      the `--clean` flag:

      ```bash
       rdmd scripts/build_examples.d core <group> --clean
      ```
   5. If all checks pass, commit changes and open a pull request.

## 8. CI/CD & PR Guidelines

* CI: GitHub Actions workflows are defined in `.github/workflows/`.
* PR title format: `[<module>] <short description>`
* Commit messages: Follow Conventional Commits.
* Pre-merge checks: Formatter → Linter → Tests → Coverage report. CI fails if formatting changes are needed.

## 9. Directory Structure

```
/
├─ .github/   # GitHub Actions workflows and templates
├─ .codex/    # Reflection records and archive
├─ docs/      # Additional design notes
├─ examples/  # Sample usage grouped by feature
├─ scripts/   # Helper build and test tools
├─ source/    # Library source code
├─ dub.json   # Dub package configuration
├─ README.md  # Project overview
└─ AGENTS.md  # Development guide
```

## 10. Reflection & Improvement

After completing your tasks, the agent **must create** a new file in `.codex/reflections/` named `YYYY-MM-DD-hhmm-{task-summary}.md`. Start the file with the exact block found in `.codex/reflection-template.md`. The header must be in the format `### :book: Reflection for [YYYY-MM-DD HH:MM]` (note the required square brackets).

```
### :book: Reflection for [2025-06-13 14:28]
```

Existing reflections before mid-2025 may omit these brackets. Update their
headers when modifying or archiving those files to maintain consistency.

> **One Bold Change rule**: every reflection must propose **exactly one** high-leverage improvement that could eliminate the biggest pain point next time. The `Proposed Improvement` section must contain a single bullet with no placeholders.

* Records are keyed by timestamp (to the minute). Use the current date and time as `YYYY-MM-DD HH:MM` in the template and file name.
* Replace `{task-summary}` with a short hyphenated summary of the task.
* When documenting pain points, include your environment (CI, local machine, OS, etc.) and specify which step or command was slow.
* After your proposed improvement is implemented, run `rdmd scripts/archive_reflection.d <file>` to move the reflection to `.codex/archive/` and log the archive. See [`.codex/reflections/AGENTS.md`](.codex/reflections/AGENTS.md) for the full workflow.
* Review all outstanding improvements:

  ```bash
  rdmd scripts/list_reflections.d
  ```

## 11. Helper Scripts and Quick Experiments

* Run project scripts with `rdmd`:

  ```bash
  rdmd scripts/build_examples.d core
  ```

  Replace `build_examples.d` with any helper in `scripts`.

* For quick experiments, run a single D file directly:

  ```bash
  rdmd path/to/file.d
  ```

* A helper for syncing example dependency locks is planned.
## 12. Updating Dependencies

* To add or update a dependency to the latest release in one command:

  ```bash
  dub add <package>@*
  ```

* To upgrade every dependency across the repository:

  ```bash
  dub upgrade --sub-packages
  ```

  This refreshes `dub.selections.json` with the newest versions.

* After upgrading, run the formatter, linter, tests, and coverage before committing.

## 13. Code-Base Insights

* Cache `dfmt` and `dscanner` binaries locally to avoid repeated downloads when running the formatter or linter.
* Build examples with `rdmd scripts/build_examples.d core <group> --clean` to remove artifacts automatically. The script recognizes directories with underscores when provided explicitly.
* Prefer `QueryParamsBuilder` (in `openai.clients.helpers`) for constructing URLs with optional query parameters.
* Keep relevant OpenAPI spec snippets under `docs/` for quick reference.
* Reflection files must use bracketed timestamps and a single bullet under **Proposed Improvement**.
