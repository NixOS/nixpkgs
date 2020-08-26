{ stdenv, fetchurl, cmake, llvmPackages, python2 }:

stdenv.mkDerivation rec {
  pname = "include-what-you-use";
  # Also bump llvmPackages in all-packages.nix to the supported version!
  version = "0.14";

  src = fetchurl {
    sha256 = "1vq0c8jqspvlss8hbazml44fi0mbslgnp2i9wcr0qrjpvfbl6623";
    url = "${meta.homepage}/downloads/${pname}-${version}.src.tar.gz";
  };

  buildInputs = with llvmPackages; [ clang-unwrapped llvm python2 ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DIWYU_LLVM_ROOT_PATH=${llvmPackages.clang-unwrapped}" ];

  enableParallelBuilding = true;

  postInstall = ''
    substituteInPlace $out/bin/iwyu_tool.py \
      --replace "'include-what-you-use'" "'$out/bin/include-what-you-use'"
  '';

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
    homepage = "https://include-what-you-use.org";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
