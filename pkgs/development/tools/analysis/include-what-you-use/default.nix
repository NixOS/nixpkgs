{ stdenv, fetchurl, cmake, llvmPackages }:

stdenv.mkDerivation rec {
  name = "include-what-you-use-${version}";
  # Also bump llvmPackages in all-packages.nix to the supported version!
  version = "0.8";

  src = fetchurl {
    sha256 = "0r6n5gqicl0f9c8jrphq40kc2cis952gmnkm3643m3jwad0mn33d";
    url = "${meta.homepage}/downloads/${name}.src.tar.gz";
  };

  buildInputs = with llvmPackages; [ clang-unwrapped llvm ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DIWYU_LLVM_ROOT_PATH=${llvmPackages.clang-unwrapped}" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Analyze #includes in C/C++ source files with clang";
    longDescription = ''
      For every symbol (type, function variable, or macro) that you use in
      foo.cc, either foo.cc or foo.h should #include a .h file that exports the
      declaration of that symbol.  The main goal of include-what-you-use is to
      remove superfluous #includes, both by figuring out what #includes are not
      actually needed for this file (for both .cc and .h files), and by
      replacing #includes with forward-declares when possible.
    '';
    homepage = https://include-what-you-use.org;
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
