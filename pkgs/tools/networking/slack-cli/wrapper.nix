{ lib, writeShellScriptBin, curl, jq }:

slack-cli:

writeShellScriptBin "slack" ''
  [ "$1" = "init" -a -z "$SLACK_CLI_TOKEN" ] && cat >&2 <<-'MESSAGE'
  WARNING: slack-cli must be configured using the SLACK_CLI_TOKEN environment
  variable. Using `slack init` will not work because it tries to write to the
  Nix store.

  MESSAGE

  export PATH=${lib.makeBinPath [ curl jq ]}:"$PATH"
  exec ${slack-cli}/bin/slack "$@"
''
