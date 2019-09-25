workflow "Test and deploy" {
  on = "push"
  resolves = [
    "Lint Json",
    "Deploy to Heroku",
  ]
}

action "Install dependencies" {
  uses = "actions/npm@master"
  args = "install"
}

action "Lint Vue" {
  uses = "actions/npm@master"
  needs = ["Install dependencies"]
  args = "run lint"
}

action "Lint Json" {
  uses = "actions/npm@master"
  needs = ["Install dependencies"]
  args = "run lint-input"
}

action "Build Vue app" {
  uses = "actions/npm@3c8332795d5443adc712d30fa147db61fd520b5a"
  needs = ["Lint Vue", "Lint Json"]
  args = "run build"
}

action "Login to Heroku" {
  uses = "actions/heroku@master"
  needs = ["Build Vue app"]
  args = "container:login"
  secrets = ["HEROKU_API_KEY"]
}

action "Push to Heroku" {
  uses = "actions/heroku@master"
  needs = ["Login to Heroku"]
  args = "container:push -a hidden-retreat-39381 web"
  secrets = ["HEROKU_API_KEY"]
}

action "Deploy to Heroku" {
  uses = "actions/heroku@master"
  needs = ["Push to Heroku"]
  secrets = ["HEROKU_API_KEY"]
  args = "container:release -a hidden-retreat-39381 web"
}