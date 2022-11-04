# tree-sitter libraries, binaries & grammars

This packages tree sitter and its grammars.

The grammar descriptions can be found in [./grammars.toml]().

## Updating tree-sitter

1) change all hashes at the beginning of [./default.nix]().
2) Update the grammars (see below)

## Updating all grammars

First you need a github Personal Access Token, otherwise it runs into rate limits.
Go to https://github.com/settings/tokens and generate a classic token, copy the secret.

You generate the update script and run it:

```bash
$ nix-build -A tree-sitter.updater.update-all-grammars
$ env GITHUB_TOKEN=<secret token> ./result
```

This will prefetch all repos mentioned in [./grammars.toml]() and put their new hashes
into the [./grammars]() directory.

If a new repository was added to the `github.com/tree-sitter` organization,
the update process will throw an error and you need to add the new repo to
either `knownTreeSitterOrgGrammarRepos` (if it’s a grammar) or to
`ignoredTreeSitterOrgRepos`.
This is to make sure we always package every official grammar.

## Adding a third-party grammar

Add it to the `otherGrammars` section in [./grammars.toml]().
The grammar name has to be unique among all grammars (upstream and third party).

## Deleting a grammar

In case a grammar needs to be removed, please remove the generated outputs
in the [./grammar]() directory manually.
