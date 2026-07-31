terraform {
  backend "local" {
    path = "./.ic_state/website/terraform.tfstate"
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

import {
  to = github_repository.website
  id = "nheimlich.github.io"
}

provider "github" {}

resource "github_repository" "website" {
  name                        = "nheimlich.github.io"
  description                 = "Personal Website"
  visibility                  = "public"
  allow_merge_commit          = true
  allow_rebase_merge          = true
  allow_update_branch         = false
  allow_squash_merge          = true
  delete_branch_on_merge      = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = "https://nhlabs.org"
  web_commit_signoff_required = true
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }
}

resource "github_repository_ruleset" "website_main_protection" {
  name        = "website-protection"
  repository  = github_repository.website.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  rules {
    deletion                = true
    non_fast_forward        = true
    required_linear_history = true
    required_signatures     = true
  }
}
