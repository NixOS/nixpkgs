{ lib, stdenv, fetchurl, bison, flex, libsepol }:

stdenv.mkDerivation rec {
  pname = "checkpolicy";
  version = "3.3";
  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/checkpolicy-${version}.tar.gz";
    sha256 = "118l8c2vvnnckbd269saslr7adv6rdavr5rv0z5vh2m1lgglxj15";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libsepol ];

  makeFlags = [
    "PREFIX=$(out)"
    "LIBSEPOLA=${lib.getLib libsepol}/lib/libsepol.a"
  ];

  meta = removeAttrs libsepol.meta ["outputsToInstall"] // {
    description = "SELinux policy compiler";
  };
}
