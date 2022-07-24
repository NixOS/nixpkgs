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
    cat <<SCRIPT >"$out/bin/blesh-share"
    #!${runtimeShell}
    # Run this script to find the ble.sh shared folder
    # where all the shell scripts are living.
    echo "$out/share/ble.sh"
    SCRIPT
    chmod +x "$out/bin/blesh-share"

    mkdir -p "$out/share/lib"
    cat <<SCRIPT >"$out/share/lib/_package.sh"
    _ble_base_package_type=nix

    function ble/base/package:nix/update {
      if ! nix-env --query ble.sh >/dev/null 2>&1; then
        echo "Upgrade nix and rebuild the system to update ble.sh" >/dev/stderr
        return 1
      fi
      nix-env --upgrade --attr nixpkgs.blesh
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
