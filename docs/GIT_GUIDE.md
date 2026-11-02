# Putting this project on GitHub (macOS, Apple silicon)

## 1. One-time Git setup
```bash
xcode-select --install            # skip if already done; gives you git
git --version

git config --global user.name  "Your Name"
git config --global user.email "you@example.com"      # use the email on your GitHub account
git config --global init.defaultBranch main
```

## 2. Sign in to GitHub (easiest: GitHub CLI)
```bash
brew install gh
gh auth login
```
Choose: **GitHub.com → HTTPS → Login with a web browser**, paste the one-time code. Check with `gh auth status`.

*(No account yet? Create one at https://github.com/signup first.)*

## 3. Initialise the repository
```bash
cd ~/path/to/Exp10_Xamarin_Layouts_Views
git init -b main
git status                        # bin/ and obj/ must NOT appear (the .gitignore hides them)
```

## 4. First commit
```bash
git add .
git commit -m "Experiment 10: Xamarin/MAUI layouts and views dashboard"
git log --oneline
```

## 5A. Create the GitHub repo and push – one command
```bash
gh repo create xamarin-layouts-views --public --source=. --remote=origin --push
```
(`--private` if your teacher doesn't need to see it publicly.)

## 5B. …or do it by hand in the browser
1. https://github.com/new → name `xamarin-layouts-views` → **do not** tick "Add README/.gitignore" → *Create repository*.
2. Back in Terminal:
```bash
git remote add origin https://github.com/<your-username>/xamarin-layouts-views.git
git branch -M main
git push -u origin main
```
Username + password prompt: the password is a **Personal Access Token** (GitHub → Settings → Developer settings → Tokens), or just use `gh auth login` and `gh auth setup-git` once.

## 6. Add your screenshots later
```bash
cp ~/Desktop/*.png docs/screenshots/
git add docs/screenshots
git commit -m "Add run screenshots"
git push
```

## 7. Everyday workflow
```bash
git status
git add -A
git commit -m "Describe what you changed"
git push
```

## 8. Handy tips
* Reference screenshots in the README with `![Dashboard](docs/screenshots/dashboard.png)`.
* Cloning on another machine: `git clone https://github.com/<you>/xamarin-layouts-views.git`.
* Accidentally committed `bin/` or `obj/`? `git rm -r --cached LayoutsDemo/bin LayoutsDemo/obj && git commit -m "Stop tracking build output"`.
* Add topics: `gh repo edit --add-topic xamarin --add-topic dotnet-maui`.
* Add a licence: on GitHub use *Add file → Create new file*, name it `LICENSE`, and pick a template.
