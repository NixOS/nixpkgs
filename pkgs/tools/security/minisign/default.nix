{ stdenv, fetchurl, cmake, libsodium }:

stdenv.mkDerivation rec {
  name = "minisign-${version}";
  version = "0.4";

  src = fetchurl {
    url = "https://github.com/jedisct1/minisign/archive/${version}.tar.gz";
    sha256 = "1k1dk6piaz8pw4b9zg55n4wcpyc301mkxb873njm8mki7r8raxnw";
  };

  buildInputs = [ cmake libsodium ];

  meta = with stdenv.lib; {
    description = "A simple tool for signing files and verifying signatures";
    longDescription = ''
      minisign uses public key cryptography to help facilitate secure (but not
      necessarily private) file transfer, e.g., of software artefacts. minisign
      is similar to and compatible with OpenBSD's signify.
    '';
    homepage = https://jedisct1.github.io/minisign/;
    license = licenses.isc;
    maintainers = with maintainers; [ joachifm ];
  };
}
