{ stdenv, fetchurl, makeWrapper, opencl-headers, ocl-icd, xxHash }:

stdenv.mkDerivation rec {
  pname   = "hashcat";
  version = "5.1.0";

  src = fetchurl {
    url = "https://hashcat.net/files/hashcat-${version}.tar.gz";
    sha256 = "0f73y4cg8c7a6q7x34qvpfi4g3lw6j9bnn0a13g43aqyiskflfr8";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ opencl-headers xxHash ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "COMPTIME=1337"
    "VERSION_TAG=${version}"
    "USE_SYSTEM_OPENCL=1"
    "USE_SYSTEM_XXHASH=1"
  ];

  postFixup = ''
    wrapProgram $out/bin/hashcat --prefix LD_LIBRARY_PATH : ${ocl-icd}/lib
  '';

  meta = with stdenv.lib; {
    description = "Fast password cracker";
    homepage    = https://hashcat.net/hashcat/;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ kierdavis zimbatm ];
  };
}
