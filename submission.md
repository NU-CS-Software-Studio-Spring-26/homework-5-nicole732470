https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-nicole732470/tree/hw5

https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-nicole732470/blob/hw5/.cursorignore

https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-nicole732470/blob/hw5/AGENTS.md

https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-nicole732470/blob/hw5/.cursor/rules/rails-conventions.mdc

https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-nicole732470/blob/hw5/.cursor/rules/security.mdc



## Part 3 — Ask mode

**Prompt:** Where in this codebase is todo creation and validation error rendering currently implemented? Cite the exact files and line numbers. Do not propose changes.

**Cursor returned (summary):** Creation is wired through `TodosController#create` (lines 23–35), `todo_params` (lines 74–76), `new.html.erb` (line 5), and `_form.html.erb` (lines 1–22). Validation error rendering is in `_form.html.erb` (lines 2–12) and triggered on failed save via `render :new` in `create` (lines 30–32).

**Verification:** I opened each cited file. The paths and line numbers are real — not hallucinated. `app/models/todo.rb` is still empty (no validations), so the error UI only appears if `@todo.save` fails for another reason.



## Part 3 — Plan mode

**Prompt:** I want to change the same todo behavior so that high-priority todos are visually marked on the index page. Propose a plan as a numbered list of changes, including files to edit, new tests to add, and any migration. Do not write code.

**My edits to the plan:**
- Kept the migration + visual marking steps but **scoped Part 4 to the Turbo Stream toggle story** instead of form-only marking.
- Removed the suggestion to add a new gem; kept everything within Rails/Turbo built-ins.
- Dropped optional system-test and show/JSON scope — not required for the toggle acceptance criteria.
- Aligned the controller action name with the test: `toggle_high_priority` (not `toggle_priority`).



## Part 3 — Agent mode

**Prompt:** Add a request/controller test for the todo priority toggle Turbo Stream response. Only edit the controller test file. Do not modify routes, models, controllers, or views.

https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-nicole732470/commit/eb1c4c9fe533568819617a75ce4a3dac43b5c75e



## Part 3 — Bad → good prompt

**Bad prompt:** fix the bug in todos

**Good prompt:**

Context: The relevant files are `app/controllers/todos_controller.rb`, `app/models/todo.rb`, and the todo request/controller test file.

Task: Fix the todo priority toggle so clicking the toggle flips `high_priority` and returns a Turbo Stream response.

Expected vs actual: Expected — clicking the priority toggle updates only the todo row or button without a full page reload. Actual — the feature did not exist yet.

Constraints: Do not add new gems. Use Rails/Turbo conventions. Prefer `format.turbo_stream` and a matching `.turbo_stream.erb` view. Only touch Todo, TodosController, routes, views, migration, and tests.

Done when: The automated test passes and confirms `response.media_type` is `text/vnd.turbo-stream.html`. In the browser, the Network tab shows the request Accept header includes `text/vnd.turbo-stream.html` and the response Content-Type is `text/vnd.turbo-stream.html`.



## Part 4 — Turbo Streams explanation

A **Turbo Stream** is a fragment of HTML containing `<turbo-stream>` elements. Each element tells Turbo Drive what DOM change to make (replace, update, append, etc.) without reloading the whole page.

It differs from a normal HTML response (`text/html`) because the server returns **instructions** (`text/vnd.turbo-stream.html`) instead of a full document. In the controller you use `respond_to { |format| format.turbo_stream }`, and Rails renders a matching view such as `app/views/todos/toggle_high_priority.turbo_stream.erb`.

**Verified against the [Turbo Handbook](https://turbo.hotwired.dev/handbook/streams):** the handbook states Turbo Streams use the MIME type `text/vnd.turbo-stream.html` and that a stream message can use actions like `replace` to swap an element by ID. Our implementation uses `turbo_stream.replace dom_id(@todo)` in `toggle_high_priority.turbo_stream.erb`, which matches that documented `replace` action pattern.



## Part 4 — Story

As a todo app user, I want to mark a todo as high priority from the index page so that I can quickly distinguish important tasks without reloading the page.

Acceptance criteria:

- Todo has a `high_priority` boolean attribute.
- Each todo row shows a priority toggle.
- Clicking the toggle flips the priority state.
- The response is a Turbo Stream response.
- Only the todo row or toggle updates, not the whole page.
- At least one automated test covers the toggle.



## Part 4 — Tests

```bash
bin/rails test
```

```
Running 10 tests in a single process (parallelization threshold is 50)
Run options: --seed 26332

# Running:

..........

Finished in 0.231603s, 43.1773 runs/s, 73.4015 assertions/s.
10 runs, 17 assertions, 0 failures, 0 errors, 0 skips
```



## Things I rejected from the AI

- I rejected adding a new gem because the assignment only required a small Rails/Turbo Streams feature.
- I rejected custom JavaScript because Turbo Streams already supports partial page updates cleanly.
- I rejected broad refactoring suggestions and kept the implementation scoped to the Todo model, controller, routes, views, and tests only.



https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-nicole732470/pull/2
