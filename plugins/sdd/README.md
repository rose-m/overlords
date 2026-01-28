# Spec-Driven Development (SDD) Plugin

A structured workflow for AI-assisted spec-driven development (SDD) especially for brown-field codebases with grown complexity and existing structures.

This is based on [No Vibes Allowed: Solving Hard Problems in Complex Codebases – Dex Horthy, HumanLayer](https://www.youtube.com/watch?v=rmvDxxNubIg).

## Usage

1. Start a new feature by doing initial research:
   ```
    /sdd:research_codebase [Your research question or area of interest]
    ```
    This will generate a new `research.md` file in the `docs/specs/` directory (with a dedicated folder name).

    There is no need to review the research document.

    Commit the research document to the repository.
2. Once the research is completed, `/clear` Claude to free up the full context.
3. Now run `/design_approach` to start the design process:
   ```
    /sdd:design_approach docs/specs/YYYY-MM-DD_topic-name/research.md
    ```
    This process will ask you questions about the design approach, and you will need to answer them.
    It will eventually generate a new `design.md` file in the same `docs/specs/` directory.

    Commit the design document to the repository and **get a review** before continuing.
4. Now run `/create_plan` to start the implementation planning process:
   ```
    /sdd:create_plan docs/specs/YYYY-MM-DD_topic-name/design.md
    ```
    This will generate a new `plan.md` file in the same `docs/specs/` directory.

    Commit the plan document to the repository.
5. Now run `/implement_plan` to start the implementation process:
   ```
    /sdd:implement_plan docs/specs/YYYY-MM-DD_topic-name/plan.md
    ```
    This will implement the plan.