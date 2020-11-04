{ stdenv, fetchpatch, fetchFromGitHub, cmake, python3, substituteAll }:

stdenv.mkDerivation rec {
  pname = "wabt";
  version = "1.0.19";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wabt";
    rev = version;
    sha256 = "0g1iy1icnjfkc0dadkrif4nlixpvq626023rgj02m9al64gf9hvx";
    fetchSubmodules = true;
  };

  # https://github.com/WebAssembly/wabt/pull/1408
  patches = [ (fetchpatch {
    url = "https://github.com/WebAssembly/wabt/pull/1408/commits/28505f4db6e4561cf6840af5c304a9aa900c4987.patch";
    sha256 = "1nh1ddsak6w51np17xf2r7i0czxrjslz1i4impmmp88h5bp2yjba";
  }) ];

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ "-DBUILD_TESTS=OFF" "-DCMAKE_PROJECT_VERSION=${version}" ];
  buildInputs = [ python3 ];

  meta = with stdenv.lib; {
    description = "The WebAssembly Binary Toolkit";
    longDescription = ''
      WABT (pronounced "wabbit") is a suite of tools for WebAssembly, including:
       * wat2wasm: translate from WebAssembly text format to the WebAssembly
         binary format
       * wasm2wat: the inverse of wat2wasm, translate from the binary format
         back to the text format (also known as a .wat)
       * wasm-objdump: print information about a wasm binary. Similiar to
         objdump.
       * wasm-interp: decode and run a WebAssembly binary file using a
         stack-based interpreter
       * wat-desugar: parse .wat text form as supported by the spec interpreter
         (s-expressions, flat syntax, or mixed) and print "canonical" flat
         format
       * wasm2c: convert a WebAssembly binary file to a C source and header
    '';
    homepage = "https://github.com/WebAssembly/wabt";
    license = licenses.asl20;
    maintainers = with maintainers; [ ekleog ];
    platforms = platforms.unix;
  };
}
