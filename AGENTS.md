## Stack

- **Ruby** 4.0.2
- **Rails** ~> 8.1.3
- **Database** SQLite3 (`storage/*.sqlite3`); production also uses Solid Cache / Solid Queue / Solid Cable on separate SQLite DBs
- **Web server** Puma
- **Frontend** Hotwire (Turbo Rails + Stimulus), importmap-rails, Propshaft — no npm/webpack
- **JSON** jbuilder
- **Testing** Minitest (`test/`), Capybara + Selenium WebDriver for system tests
- **Lint / security** RuboCop (rails-omakase), Brakeman, bundler-audit, importmap audit

## Commands

```bash
# Setup (install gems, prepare DB, optionally start server)
bin/setup
bin/setup --skip-server    # setup without starting the server
bin/setup --reset          # reset DB after setup

# Run
bin/dev                    # alias for bin/rails server
bin/rails server           # http://localhost:3000

# Test
bin/rails test
bin/rails test:system
bin/rails db:test:prepare test   # CI-style test run

# Lint / full CI
bin/rubocop
bin/ci                     # setup, rubocop, security scans, tests, seed check
```

## Conventions

- **MVC layout**: models in `app/models/`, controllers in `app/controllers/`, views in `app/views/<controller>/`.
- **Strong parameters**: whitelist fields in a private `*_params` method (e.g. `todo_params` permits `:description`, `:due_date`, `:done`). Never mass-assign from `params` directly.
- **Controller patterns**: use `before_action` for shared setup (`set_todo`); use `respond_to` for HTML and JSON; redirect with `status: :see_other` after mutating actions.
- **Turbo**: enabled via `turbo-rails` and importmap; keep `data-turbo-track="reload"` on asset tags in the layout. Prefer Turbo Drive/Frames over full page reload hacks.
- **JavaScript**: Stimulus controllers live in `app/javascript/controllers/`; register via importmap (`config/importmap.rb`). Entry point is `app/javascript/application.js`.
- **Partials**: place in the matching view folder with a leading underscore (e.g. `app/views/todos/_form.html.erb`, `_todo.html.erb`). Render with `render @todo` or `render "form"`.
- **Styles**: `app/assets/stylesheets/application.css` via Propshaft.
- **Routes**: define in `config/routes.rb`; use named route helpers in views (e.g. `new_todo_path`, not hardcoded URLs).
- **Tests**: controller/model tests in `test/controllers/` and `test/models/`; fixtures in `test/fixtures/`.
- **Migrations**: `bin/rails generate migration ...` then `bin/rails db:migrate`.

## Don'ts

- **No new gems** unless the task explicitly requires one — prefer Rails built-ins and existing stack.
- **No inline JavaScript** in ERB (`onclick`, `<script>` blocks, etc.) — use Stimulus controllers instead.
- **Do not disable or skip CSRF protection** (`skip_before_action :verify_authenticity_token`, removing `csrf_meta_tags`, etc.).
- **Do not bypass strong parameters** — no `params.permit!` or direct `Todo.new(params[:todo])`.
- **Do not add npm/yarn/webpack** — JS is managed through importmap only.
- **Do not commit secrets** — keep credentials in `config/credentials.yml.enc`, not plain text in the repo.
