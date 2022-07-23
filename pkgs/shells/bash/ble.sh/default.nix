{ lib, stdenvNoCC, fetchFromGitHub, git, curl, jq, nix-prefetch, bashInteractive, runtimeShell }:

stdenvNoCC.mkDerivation rec {
  name = "ble.sh";
  version = "2022-07-21";

  src = fetchFromGitHub {
    owner = "akinomyoga";
    repo = "ble.sh";
    rev = "a45077599d5c48d946de6e9b3c4baaaae9fc2633";
    hash = "sha256-YUfDr3wmv7UGAoDQJBuXve0R34cQua4OyooppYXJIlU=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  nativeBuildInputs = [ git ];
  buildInputs = [ curl jq nix-prefetch ];

  doCheck = true;
  checkInputs = [ bashInteractive ];

  installFlags = [ "INSDIR=$(out)/share" ];
  postInstall = ''
    mkdir -p "$out/bin"
    cat <<SCRIPT >"$out/bin/ble.sh-share"
    #!${runtimeShell}
    # Run this script to find the ble.sh shared folder
    # where all the shell scripts are living.
    echo "$out/share/ble.sh"
    SCRIPT
    chmod +x "$out/bin/ble.sh-share"

    mkdir -p "$out/share/lib"
    cat <<SCRIPT >"$out/share/lib/_package.sh"
    _ble_base_package_type=nix

    function ble/base/package:nix/update {
      local rev=\$(${curl}/bin/curl -sL 'https://api.github.com/repos/akinomyoga/ble.sh/branches/master' | ${jq}/bin/jq -r '.commit.sha')
      [[ "\$rev" == "${src.rev}" ]] && return 6

      # We use fetchgit here, because nix-prefetch's fetchFromGitHub is broken
      local hash="\$(${nix-prefetch}/bin/nix-prefetch fetchgit --url 'https://github.com/akinomyoga/ble.sh.git' --branchName master --rev \$rev --leaveDotGit --fetchSubmodules 2>/dev/null)"

      cat <<STDERR >/dev/stderr
    You cannot update ble.sh to the latest version with Nix.
    The latest ble.sh from master branch can be installed by overriding nixpkgs like following.

      pkgs.ble-sh.overrideAttrs (_: {
        src = pkgs.fetchFromGitHub {
          owner = "akinomyoga";
          repo = "ble.sh";
          rev = "\$rev";
          hash = "\$hash";
          fetchSubmodules = true;
          leaveDotGit = true;
        };
      });
    STDERR
      return 1
    }
    SCRIPT
  '';

  meta = with lib; {
    homepage = "https://github.com/akinomyoga/ble.sh";
    description = "Bash Line Editor -- a full-featured line editor written in pure Bash";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aiotter ];
    platforms = platforms.unix;
  };
}
