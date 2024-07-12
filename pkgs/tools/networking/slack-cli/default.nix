# slack-cli must be configured using the SLACK_CLI_TOKEN environment variable.
# Using `slack init` will not work because it tries to write to the Nix store.
#
# There is no reason that we couldn't change the file path that slack-cli uses
# for token storage, except that it would make the Nix package inconsistent with
# upstream and other distributions.

{ stdenv, lib, fetchFromGitHub, curl, jq, coreutils, gnugrep, gnused
, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "slack-cli";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "rockymadden";
    repo = "slack-cli";
    rev = "v${version}";
    sha256 = "022yr3cpfg0v7cxi62zzk08vp0l3w851qpfh6amyfgjiynnfyddl";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin"
    cp src/slack "$out/bin/.slack-wrapped"

    cat <<-WRAPPER > "$out/bin/slack"
    #!${runtimeShell}
    [ "\$1" = "init" -a -z "\$SLACK_CLI_TOKEN" ] && cat <<-'MESSAGE' >&2
    WARNING: slack-cli must be configured using the SLACK_CLI_TOKEN
    environment variable. Using \`slack init\` will not work because it tries
    to write to the Nix store.

    MESSAGE

    export PATH=${lib.makeBinPath [ curl jq coreutils gnugrep gnused ]}:"\$PATH"
    exec "$out/bin/.slack-wrapped" "\$@"
    WRAPPER

    chmod +x "$out/bin/slack"
  '';

  meta = {
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "slack";
    platforms = lib.platforms.unix;
  };
}
