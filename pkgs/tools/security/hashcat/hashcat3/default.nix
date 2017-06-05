{ stdenv, fetchurl, makeWrapper, opencl-headers, ocl-icd }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name    = "hashcat-${version}";
  version = "3.10";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://hashcat.net/files_legacy/hashcat-${version}.tar.gz";
    sha256 = "1sg30d9as6xsl7b0i7mz26igachbv0l0yimwb12nmarmgdgmwm9v";
  };

  buildInputs = [ opencl-headers makeWrapper ];

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
    homepage    = http://hashcat.net/hashcat/;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.kierdavis ];
  };
}
