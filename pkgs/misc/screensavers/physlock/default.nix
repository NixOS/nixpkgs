{ lib, stdenv, fetchFromGitHub, pam, systemd }:

stdenv.mkDerivation rec {
  version = "v13";
  pname = "physlock";
  src = fetchFromGitHub {
    owner = "muennich";
    repo = pname;
    rev = version;
    sha256 = "1mz4xxjip5ldiw9jgfq9zvqb6w10bcjfx6939w1appqg8f521a7s";
  };

  buildInputs = [ pam systemd ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace "-m 4755 -o root -g root" ""
  '';

  makeFlags = [ "PREFIX=$(out)" "SESSION=systemd" ];

  meta = with lib; {
    description = "A secure suspend/hibernate-friendly alternative to `vlock -an`";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
