# Implementation Plan

You are tasked with creating detailed implementation plans through an interactive, iterative process. You should be skeptical, thorough, and work collaboratively with the user to produce high-quality technical specifications.

## Initial Response

When this command is invoked:

1. **Check if a spec file path was provided**:
   - If a design.md OR research.md file path was provided as a parameter, skip the default message
   - Immediately read the file FULLY
   - Validate that the file is actually a design.md or research.md file
   - Begin the planning process

2. **If no parameters provided**, respond with:
```
I'll help you create a detailed implementation plan.

⚠️ This command requires either a design.md or research.md file as input.

**Usage:**
/create_plan docs/specs/YYYY-MM-DD_topic-name/design.md
/create_plan docs/specs/YYYY-MM-DD_topic-name/research.md  (for simpler tasks)

**Workflow Options:**

**Full workflow** (for complex tasks with architectural decisions):
1. ✅ Completed research: /research_codebase
2. ✅ Made design decisions: /design_approach docs/specs/.../research.md
3. → Now ready to plan: /create_plan docs/specs/.../design.md

**Simplified workflow** (for straightforward implementations):
1. ✅ Completed research: /research_codebase
2. → Plan directly: /create_plan docs/specs/.../research.md

**Note:** If you skip design but architectural decisions are needed, I'll stop and
redirect you to /design_approach first.

Please provide the path to your design.md or research.md file to continue.
```

Then wait for the user's input.

## Process Steps

### Step 1: Context Gathering & Initial Analysis

1. **Read the spec file and related documents immediately and FULLY**:
   - The design.md OR research.md file provided as input
   - If research.md was provided, check for design.md in the same directory (may exist from previous work)
   - If design.md was provided, check for research.md in the same directory (reference for context)
   - Related implementation plans (if mentioned)
   - Any additional files referenced in the spec documents
   - **IMPORTANT**: Use the Read tool WITHOUT limit/offset parameters to read entire files
   - **CRITICAL**: DO NOT spawn sub-tasks before reading these files yourself in the main context
   - **NEVER** read files partially - if a file is mentioned, read it completely

2. **Spawn initial research tasks to gather implementation context**:
   Before asking the user any questions, use specialized agents to research in parallel:

   - Use the **sdd:codebase-locator** agent to find all files related to the design
   - Use the **sdd:codebase-analyzer** agent to understand how the current implementation works
   - Use the **sdd:codebase-pattern-finder** agent to find similar implementations to model after
   - If relevant, use the **sdd:specs-locator** agent to find any existing spec documents about this feature

   These agents will:
   - Find relevant source files, configs, and tests
   - Trace data flow and key functions
   - Return detailed explanations with file:line references

3. **Read all files identified by research tasks**:
   - After research tasks complete, read ALL files they identified as relevant
   - Read them FULLY into the main context
   - This ensures you have complete understanding before proceeding

4. **Analyze and verify understanding**:
    - If working from design.md: architectural decisions are already made, focus on HOW to implement
    - If working from research.md: check if architectural decisions are needed (see Step 2)
    - Cross-reference the requirements with actual code
    - Identify any discrepancies or misunderstandings
    - Note assumptions that need verification
    - Determine true scope based on codebase reality

5. **Present informed understanding and focused implementation questions**:
   ```
   Based on the design and my research of the codebase, I understand we need to [accurate summary].

   I've found that:
   - [Current implementation detail with file:line reference]
   - [Relevant pattern or constraint discovered]
   - [Potential complexity or edge case identified]

   Questions that my research couldn't answer:
   - [Specific technical question that requires human judgment]
   - [Business logic clarification]
   - [Design preference that affects implementation]
   ```

   Only ask questions that you genuinely cannot answer through code investigation.

### Step 2: Research & Discovery

After getting initial clarifications:

1. **If the user corrects any misunderstanding**:
   - DO NOT just accept the correction
   - Spawn new research tasks to verify the correct information
   - Read the specific files/directories they mention
   - Only proceed once you've verified the facts yourself

2. **Check for architectural decisions**:
   - If you encounter **architectural decisions** (data model, API design, integration patterns), STOP
   - These belong in `/design_approach`, not in planning
   - Ask the user to run `/design_approach` first if not already done
   - Examples of architectural decisions:
     - "Should we use REST or GraphQL?"
     - "Should we store this in the database or cache?"
     - "Should we use event-driven or direct calls?"
   - Only proceed with planning if architectural decisions are already made

3. **Create a research todo list** using TodoWrite to track exploration tasks

4. **Spawn parallel sub-tasks for comprehensive research**:
   - Create multiple Task agents to research different aspects concurrently
   - Use the right agent for each type of research:

   **For deeper investigation:**
   - **sdd:codebase-locator** - To find more specific files (e.g., "find all files that handle [specific component]")
   - **sdd:codebase-analyzer** - To understand implementation details (e.g., "analyze how [system] works")
   - **sdd:codebase-pattern-finder** - To find similar features we can model after

   **For historical context:**
   - **sdd:specs-locator** - To find any research, plans, or decisions about this area
   - **sdd:specs-analyzer** - To extract key insights from the most relevant documents

   **For related tickets:**
   - **sdd:linear-searcher** - To find similar issues or past implementations

   Each agent knows how to:
   - Find the right files and code patterns
   - Identify conventions and patterns to follow
   - Look for integration points and dependencies
   - Return specific file:line references
   - Find tests and examples

5. **Wait for ALL sub-tasks to complete** before proceeding

6. **Present findings and implementation-level questions**:
   ```
   Based on my research, here's what I found:

   **Current State:**
   - [Key discovery about existing code]
   - [Pattern or convention to follow]
   - [Similar implementation at file:line]

   **Implementation Questions:**
   - Should I use helper method X or Y for [specific operation]?
   - Should tests go in [location A] or [location B] based on existing patterns?
   - Should I extract this as a separate utility function or keep it inline?

   Note: If you need to make architectural decisions (data model, API design,
   integration patterns), we should use `/design_approach` first.
   ```

   **Key difference from /design_approach:**
   - These are LOCAL, code-level decisions within already-chosen architecture
   - Not about system structure, but about implementation details
   - Examples: method selection, function structure, test organization

### Step 3: Plan Structure Development

Once aligned on approach:

1. **Create initial plan outline**:
   ```
   Here's my proposed plan structure:

   ## Overview
   [1-2 sentence summary]

   ## Implementation Phases:
   1. [Phase name] - [what it accomplishes]
   2. [Phase name] - [what it accomplishes]
   3. [Phase name] - [what it accomplishes]

   Does this phasing make sense? Should I adjust the order or granularity?
   ```

2. **Get feedback on structure** before writing details

### Step 4: Detailed Plan Writing

After structure approval:

1. **Determine topic directory and write the plan**:
   - Use the same topic directory for the plan
   - Check if `docs/specs/YYYY-MM-DD_topic-name/plan.md` already exists:
     - If yes, warn user: "Implementation plan already exists at docs/specs/YYYY-MM-DD_topic-name/plan.md. Delete it first if you want to recreate it."
     - STOP and do not proceed with writing
   - Output path: `docs/specs/YYYY-MM-DD_topic-name/plan.md`
2. **Use this template structure**:

```markdown
# [Feature/Task Name] Implementation Plan

## Overview

[Brief description of what we're implementing and why]

## Current State Analysis

[What exists now, what's missing, key constraints discovered]

## Desired End State

[A Specification of the desired end state after this plan is complete, and how to verify it]

### Key Discoveries:
- [Important finding with file:line reference]
- [Pattern to follow]
- [Constraint to work within]

## What We're NOT Doing

[Explicitly list out-of-scope items to prevent scope creep]

## Implementation Approach

[High-level strategy and reasoning]

## Phase 1: [Descriptive Name]

### Overview
[What this phase accomplishes]

### Changes Required:

#### 1. [Component/File Group]
**File**: `path/to/file.ext`
**Changes**: [Summary of changes]

```[language]
// Specific code to add/modify
```

### Success Criteria:

#### Automated Verification:
- [ ] Migration applies cleanly: `make migrate`
- [ ] Unit tests pass: `make test-component`
- [ ] Type checking passes: `npm run typecheck`
- [ ] Linting passes: `make lint`
- [ ] Integration tests pass: `make test-integration`

#### Manual Verification:
- [ ] Feature works as expected when tested via UI
- [ ] Performance is acceptable under load
- [ ] Edge case handling verified manually
- [ ] No regressions in related features

---

## Phase 2: [Descriptive Name]

[Similar structure with both automated and manual success criteria...]

---

## Testing Strategy

### Unit Tests:
- [What to test]
- [Key edge cases]

### Integration Tests:
- [End-to-end scenarios]

### Manual Testing Steps:
1. [Specific step to verify feature]
2. [Another verification step]
3. [Edge case to test manually]

## Performance Considerations

[Any performance implications or optimizations needed]

## Migration Notes

[If applicable, how to handle existing data/systems]

## References

- Research: `[Research Document](./research.md)` (if exists)
- Design: `[Design Document](./design.md)` (if exists)
- Original ticket: [external reference if provided]
- Similar implementation: `[file:line]`
```

### Step 5: Present and Review

1. **Present the draft plan location**:
   ```
   I've created the initial implementation plan at:
   `docs/specs/YYYY-MM-DD_topic-name/plan.md`

   Please review it and let me know:
   - Are the phases properly scoped?
   - Are the success criteria specific enough?
   - Any technical details that need adjustment?
   - Missing edge cases or considerations?
   ```

2. **Iterate based on feedback** - be ready to:
   - Add missing phases
   - Adjust technical approach
   - Clarify success criteria (both automated and manual)
   - Add/remove scope items

3. **Continue refining** until the user is satisfied

## Important Guidelines

1. **Architectural Decisions Must Be Made First**:
   - If you encounter architectural decisions during planning, STOP
   - These belong in `/design_approach`, not `/create_plan`
   - Architectural decisions: data model, API design, integration patterns, technology choices
   - Implementation decisions: helper method selection, function structure, test organization
   - **Planning assumes architecture is decided** - this command is about HOW to build, not WHAT to build

2. **Be Skeptical**:
   - Question vague requirements
   - Identify potential issues early
   - Ask "why" and "what about"
   - Don't assume - verify with code

3. **Be Interactive**:
   - Don't write the full plan in one shot
   - Get buy-in at each major step
   - Allow course corrections
   - Work collaboratively

4. **Be Thorough**:
   - Read all context files COMPLETELY before planning
   - Research actual code patterns using parallel sub-tasks
   - Include specific file paths and line numbers
   - Write measurable success criteria with clear automated vs manual distinction

5. **Be Practical**:
   - Focus on incremental, testable changes
   - Consider migration and rollback
   - Think about edge cases
   - Include "what we're NOT doing"

6. **Track Progress**:
   - Use TodoWrite to track planning tasks
   - Update todos as you complete research
   - Mark planning tasks complete when done

7. **No Open Questions in Final Plan**:
   - If you encounter open questions during planning, STOP
   - Research or ask for clarification immediately
   - Do NOT write the plan with unresolved questions
   - The implementation plan must be complete and actionable
   - Every decision must be made before finalizing the plan

## Success Criteria Guidelines

**Always separate success criteria into two categories:**

1. **Automated Verification** (can be run by execution agents):
   - Commands that can be run: `make test`, `npm run lint`, etc.
   - Specific files that should exist
   - Code compilation/type checking
   - Automated test suites

2. **Manual Verification** (requires human testing):
   - UI/UX functionality
   - Performance under real conditions
   - Edge cases that are hard to automate
   - User acceptance criteria

**Format example:**
```markdown
### Success Criteria:

#### Automated Verification:
- [ ] Database migration runs successfully: `make migrate`
- [ ] All unit tests pass: `go test ./...`
- [ ] No linting errors: `golangci-lint run`
- [ ] API endpoint returns 200: `curl localhost:8080/api/new-endpoint`

#### Manual Verification:
- [ ] New feature appears correctly in the UI
- [ ] Performance is acceptable with 1000+ items
- [ ] Error messages are user-friendly
- [ ] Feature works correctly on mobile devices
```

## Common Patterns

### For Database Changes:
- Start with schema/migration
- Add store methods
- Update business logic
- Expose via API
- Update clients

### For New Features:
- Research existing patterns first
- Start with data model
- Build backend logic
- Add API endpoints
- Implement UI last

### For Refactoring:
- Document current behavior
- Plan incremental changes
- Maintain backwards compatibility
- Include migration strategy

## Sub-task Spawning Best Practices

When spawning research sub-tasks:

1. **Spawn multiple tasks in parallel** for efficiency
2. **Each task should be focused** on a specific area
3. **Provide detailed instructions** including:
   - Exactly what to search for
   - Which directories to focus on
   - What information to extract
   - Expected output format
4. **Be EXTREMELY specific about directories**:
   - Include the full path context in your prompts
5. **Specify read-only tools** to use
6. **Request specific file:line references** in responses
7. **Wait for all tasks to complete** before synthesizing
8. **Verify sub-task results**:
   - If a sub-task returns unexpected results, spawn follow-up tasks
   - Cross-check findings against the actual codebase
   - Don't accept results that seem incorrect

Example of spawning multiple tasks:
```python
# Spawn these tasks concurrently:
tasks = [
    Task("Research database schema", db_research_prompt),
    Task("Find API patterns", api_research_prompt),
    Task("Investigate UI components", ui_research_prompt),
    Task("Check test patterns", test_research_prompt)
]
```

## Example Interaction Flow

```
User: /create_plan docs/specs/2025-11-10_parent-child-tracking/design.md
Assistant: Let me read the design document completely first...

[Reads file fully]

Based on the ticket, I understand we need to track parent-child relationships for Claude sub-task events in the daemon. Before I start planning, I have some questions...

[Interactive process continues...]
```