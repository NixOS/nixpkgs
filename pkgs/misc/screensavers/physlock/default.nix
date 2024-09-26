{ lib, stdenv, fetchFromGitHub, pam, systemd }:

stdenv.mkDerivation rec {
  version = "2020-07-28";
  pname = "physlock";
  src = fetchFromGitHub {
    owner = "menglishca";
    repo = pname;
    rev = "9618016bee86c7af6121f96b4a54e85d8a49d3d1";
    sha256 = "sha256-VzwT2aAflmjTWJMxJYQAH/jas/WOljgvrBDXP/bZ7ZU=";
  };

  buildInputs = [ pam systemd ];

  patches = [
    ./fix_options_struct.patch
  ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace "-m 4755 -o root -g root" ""
  '';

  makeFlags = [ "PREFIX=$(out)" "SESSION=systemd" ];

  meta = with lib; {
    description = "Secure suspend/hibernate-friendly alternative to `vlock -an`";
    mainProgram = "physlock";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
