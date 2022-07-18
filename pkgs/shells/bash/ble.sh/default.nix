{ lib, stdenv, git, fetchgit }:

stdenv.mkDerivation {
  name = "ble.sh";
  version = "0.3.3";

  nativeBuildInputs = [ git ];

  src = fetchgit {
    url = "https://github.com/akinomyoga/ble.sh.git";
    rev = "refs/tags/v0.3.3";
    hash = "sha256-Gfo2S1t5Kdy+8TEDS4M5yhyRShvzQIljdE0MQK1CL+4=";
    fetchSubmodules = true;
  };

  doCheck = true;

  postInstall = ''
    mkdir -p "$out/bin"
    echo 'source "$(dirname "$BASH_SOURCE")/../share/ble.sh"' >"$out/bin/ble.sh"
    chmod +x "$out/bin/ble.sh"
    '';

  makeFlags = [ "INSDIR=$(out)/share" ];

  meta = with lib; {
    homepage = "https://github.com/akinomyoga/ble.sh";
    description = "Bash Line Editor -- a full-featured line editor written in pure Bash";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aiotter ];
    platforms = platforms.unix;
  };
}
