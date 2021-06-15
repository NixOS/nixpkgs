{ lib
, vscode-utils
, useLocalExtensions ? false}:
# Note that useLocalExtensions requires that vscode-server is not running
# on host. If it is, you'll need to remove $HOME/.vscode-server,
# and redo the install by running "Connect to host" on client

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  # patch runs on remote machine hence use of which
  # links to local node if version is 12
  patch = ''
    f="$HOME/.vscode-server/bin/$COMMIT_ID/node"
    localNodePath=''$(which node)
    if [ -x "''$localNodePath" ]; then
      localNodeVersion=''$(node -v)
      if [ "\''${localNodeVersion:1:2}" = "12" ]; then
        echo PATCH: replacing ''$f with ''$localNodePath
        rm ''$f
        ln -s ''$localNodePath ''$f
      fi
    fi
    ${lib.optionalString useLocalExtensions ''
      # Use local extensions
      if [ -d $HOME/.vscode/extensions ]; then
        if ! test -L "$HOME/.vscode-server/extensions"; then
          mkdir -p $HOME/.vscode-server
          ln -s $HOME/.vscode/extensions $HOME/.vscode-server/
        fi
      fi
    ''}
  '';
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "remote-ssh";
      publisher = "ms-vscode-remote";
      version = "0.50.0";
      sha256 = "01pyd6759p5nkjhjy3iplrl748xblr54l1jphk2g02s1n5ds2qb9";
    };

    postPatch = ''
      substituteInPlace "out/extension.js" \
        --replace "# install extensions" '${patch}'
    '';

    meta = with lib; {
      description ="Use any remote machine with a SSH server as your development environment.";
      license = licenses.unfree;
      maintainers = with maintainers; [
        tbenst
      ];
    };
  }
