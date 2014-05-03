{ stdenv, fetchgit
, x11, mesa
, linuxPackages
}:
let
  version = "1.0.0";
in
stdenv.mkDerivation {
  name = "primus-${version}";
  src = fetchgit {
    url = git://github.com/amonakov/primus.git;
    rev = "074817614c014e3a99259388cb18fd54648b659a";
    sha256 = "0mrh432md6zrm16avxyk57mgszrqpgwdjahspchvlaccqxp3x82v";
  };

  nvidia = linuxPackages.nvidia_x11;

  buildInputs = [ x11 mesa ];
  builder = ./builder.sh;
}
