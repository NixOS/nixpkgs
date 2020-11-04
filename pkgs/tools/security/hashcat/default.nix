{ stdenv
, fetchurl
, makeWrapper
, opencl-headers
, ocl-icd
, xxHash
}:

stdenv.mkDerivation rec {
  pname   = "hashcat";
  version = "6.1.1";

  src = fetchurl {
    url = "https://hashcat.net/files/hashcat-${version}.tar.gz";
    sha256 = "104z63m7lqbb0sdrxhf9yi15l4a9zwf9m6zs9dbb3gf0nfxl1h9r";
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
    homepage    = "https://hashcat.net/hashcat/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ kierdavis zimbatm ];
  };
}
