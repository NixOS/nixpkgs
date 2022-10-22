{ lib, stdenv, fetchurl, cmake, llvmPackages, python3 }:

stdenv.mkDerivation rec {
  pname = "include-what-you-use";
  # Also bump llvmPackages in all-packages.nix to the supported version!
  version = "0.18";

  src = fetchurl {
    sha256 = "sha256-kQL8hBkpR1ffhqic5uwwX42QqBjR8lmKE50V6xiUuPM=";
    url = "${meta.homepage}/downloads/${pname}-${version}.src.tar.gz";
  };

  nativeBuildInputs = with llvmPackages; [ cmake llvm.dev llvm python3];
  buildInputs = with llvmPackages; [ libclang clang-unwrapped ];

  cmakeFlags = [ "-DIWYU_LLVM_ROOT_PATH=${llvmPackages.clang-unwrapped}" ];

  postInstall = ''
    substituteInPlace $out/bin/iwyu_tool.py \
      --replace "'include-what-you-use'" "'$out/bin/include-what-you-use'"
  '';

  meta = with lib; {
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
