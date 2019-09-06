{ stdenv, fetchFromGitHub, pam, systemd }:

stdenv.mkDerivation {
  version = "11-dev";
  pname = "physlock";
  src = fetchFromGitHub {
    owner = "muennich";
    repo = "physlock";
    rev = "31cc383afc661d44b6adb13a7a5470169753608f";
    sha256 = "0j6v8li3vw9y7vwh9q9mk1n1cnwlcy3bgr1jgw5gcv2am2yi4vx3";
  };

  buildInputs = [ pam systemd ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace /usr/local $out \
      --replace "-m 4755 -o root -g root" ""
  '';

  makeFlags = "SESSION=systemd";

  meta = with stdenv.lib; {
    description = "A secure suspend/hibernate-friendly alternative to `vlock -an`";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
