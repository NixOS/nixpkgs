{ lib, stdenvNoCC, fetchgit, git, runtimeShell }:

stdenvNoCC.mkDerivation {
  name = "ble.sh";
  version = "0.3.3";

  src = fetchgit {
    url = "https://github.com/akinomyoga/ble.sh.git";
    rev = "refs/tags/v0.3.3";
    hash = "sha256-Gfo2S1t5Kdy+8TEDS4M5yhyRShvzQIljdE0MQK1CL+4=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  nativeBuildInputs = [ git ];

  doCheck = true;

  installFlags = [ "INSDIR=$(out)/share" ];
  postInstall = ''
    mkdir -p "$out/bin"
    cat <<SCRIPT > "$out/bin/ble.sh-share"
    #!${runtimeShell}
    # Run this script to find the ble.sh shared folder
    # where all the shell scripts are living.
    echo "$out/share/ble.sh"
    SCRIPT
    chmod +x "$out/bin/ble.sh-share"
  '';

  meta = with lib; {
    homepage = "https://github.com/akinomyoga/ble.sh";
    description = "Bash Line Editor -- a full-featured line editor written in pure Bash";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aiotter ];
    platforms = platforms.unix;
  };
}
