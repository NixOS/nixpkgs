{ lib
, stdenvNoCC
, fetchFromGitHub
, git
, bashInteractive
, glibcLocales
, runtimeShell
}:

stdenvNoCC.mkDerivation rec {
  name = "blesh";
  version = "unstable-2022-07-24";

  src = fetchFromGitHub {
    owner = "akinomyoga";
    repo = "ble.sh";
    rev = "0b95d5d900b79a63e7f0834da5aa7276b8332a44";
    hash = "sha256-s/RQKcAFcCUB3Xd/4uOsIgigOE0lCCeVC9K3dfnP/EQ=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  nativeBuildInputs = [ git ];

  doCheck = true;
  checkInputs = [ bashInteractive glibcLocales ];
  preCheck = "export LC_ALL=en_US.UTF-8";

  installFlags = [ "INSDIR=$(out)/share" ];
  postInstall = ''
    mkdir -p "$out/bin"
    cat <<EOF >"$out/bin/blesh-share"
    #!${runtimeShell}
    # Run this script to find the ble.sh shared folder
    # where all the shell scripts are living.
    echo "$out/share/ble.sh"
    EOF
    chmod +x "$out/bin/blesh-share"

    mkdir -p "$out/share/lib"
    cat <<EOF >"$out/share/lib/_package.sh"
    _ble_base_package_type=nix

    function ble/base/package:nix/update {
      echo "Ble.sh is installed by Nix. You can update it there." >/dev/stderr
      return 1
    }
    EOF
  '';

  meta = with lib; {
    homepage = "https://github.com/akinomyoga/ble.sh";
    description = "Bash Line Editor -- a full-featured line editor written in pure Bash";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aiotter ];
    platforms = platforms.unix;
  };
}
