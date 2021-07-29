{ lib, stdenv, fetchFromGitHub, coreutils, makeWrapper
, rsync, python3 }:

stdenv.mkDerivation rec {
  pname = "mergerfs-tools";
  version = "20210502";

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = pname;
    rev = "3b6fe008517aeda715c306eaf4914f6f537da88d";
    sha256 = "sha256-TQGlvFBYoVO8Qa8rAfIbTgTIsW1I3MfYKT5uwkz175Y=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  makeFlags = [
    "INSTALL=${coreutils}/bin/install"
    "PREFIX=${placeholder "out"}"
  ];

  postInstall =
    let
      binPath = lib.makeBinPath [
        rsync
        python3.pkgs.xattr
      ];
    in ''
      for program in $out/bin/mergerfs.*; do
        wrapProgram "$program" --prefix PATH : ${binPath}
      done
    '';

  meta = with lib; {
    description = "Optional tools to help manage data in a mergerfs pool";
    homepage = "https://github.com/trapexit/mergerfs-tools";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
