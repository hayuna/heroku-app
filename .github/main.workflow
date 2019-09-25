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

action "ESlint" {
  uses = "actions/npm@master"
  needs = ["Install dependencies"]
  args = "run lint"
}

action "Stylelint" {
  uses = "actions/npm@master"
  needs = ["Install dependencies"]
  args = "run stylelint"
}

action "Test" {
  uses = "actions/npm@master"
  needs = ["Install dependencies"]
  args = "run test"
}

action "Build app" {
  uses = "actions/npm@master"
  needs = ["ESlint", "Stylelint", "Test"]
  args = "run build"
}

action "Login to Heroku" {
  uses = "actions/heroku@master"
  needs = ["Build app"]
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