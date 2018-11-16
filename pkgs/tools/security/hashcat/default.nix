{ stdenv, fetchurl, makeWrapper, opencl-headers, ocl-icd }:

stdenv.mkDerivation rec {
  name    = "hashcat-${version}";
  version = "4.2.1";

  src = fetchurl {
    url = "https://hashcat.net/files/hashcat-${version}.tar.gz";
    sha256 = "082k5srjwkfvnvz0bfcg5r12m9c2qjyfhnp135mparkf831p7bbx";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ opencl-headers ];

  makeFlags = [
    "OPENCL_HEADERS_KHRONOS=${opencl-headers}/include"
    "COMPTIME=1337"
    "VERSION_TAG=${version}"
  ];

  # $out is not known until the build has started.
  configurePhase = ''
    runHook preConfigure
    makeFlags="$makeFlags PREFIX=$out"
    runHook postConfigure
  '';

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
