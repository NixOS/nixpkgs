{ stdenv, fetchurl, makeWrapper, opencl-headers, ocl-icd }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name    = "hashcat-${version}";
  version = "3.6.0";

  src = fetchurl {
    url = "https://hashcat.net/files/hashcat-${version}.tar.gz";
    sha256 = "127hdvq6ikah7r5vch63jnnkcsj7y61f9h8x79c3w25x9w55bxry";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ opencl-headers ];

  makeFlags = [ "OPENCL_HEADERS_KHRONOS=${opencl-headers}/include" ];

  # $out is not known until the build has started.
  configurePhase = ''
    runHook preConfigure
    makeFlags="$makeFlags PREFIX=$out"
    runHook postConfigure
  '';

  postFixup = ''
    wrapProgram $out/bin/hashcat --prefix LD_LIBRARY_PATH : ${ocl-icd}/lib
  '';

  meta = {
    description = "Fast password cracker";
    homepage    = https://hashcat.net/hashcat/;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.kierdavis ];
  };
}
