{ stdenv, fetchurl, cmake, python }:

stdenv.mkDerivation {
  name = "opencc-1.0.5";
  src = fetchurl {
    url = "https://github.com/BYVoid/OpenCC/archive/ver.1.0.5.tar.gz";
    sha256 = "1ce1649ba280cfc88bb76e740be5f54b29a9c034400c97a3ae211c37d7030705";
  };

  buildInputs = [ cmake python ];

  makeFlags = [
    # let intermediate tools find intermediate library
    "LD_LIBRARY_PATH=$LD_LIBRARY_PATH\${LD_LIBRARY_PATH:+:}$(CURDIR)/src"
  ];

  # Parallel building occasionaly fails with: Error copying file "/tmp/nix-build-opencc-1.0.5.drv-0/OpenCC-ver.1.0.5/build/src/libopencc.so.1.0.0" to "/tmp/nix-build-opencc-1.0.5.drv-0/OpenCC-ver.1.0.5/build/src/tools".
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/BYVoid/OpenCC;
    license = licenses.asl20;
    description = "A project for conversion between Traditional and Simplified Chinese";
    longDescription = ''
      Open Chinese Convert (OpenCC) is an opensource project for conversion between
      Traditional Chinese and Simplified Chinese, supporting character-level conversion,
      phrase-level conversion, variant conversion and regional idioms among Mainland China,
      Taiwan and Hong kong.
    '';
    maintainers = [ maintainers.sifmelcara ];
    platforms = platforms.linux;
  };
}
