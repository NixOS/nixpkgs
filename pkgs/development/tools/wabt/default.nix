{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "wabt";
  version = "1.0.35";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wabt";
    rev = version;
    sha256 = "sha256-oWyHR2HRDA/N5Rm9EXhOi+lZ2N7In6HmE74ZL2Nyu9A=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DCMAKE_PROJECT_VERSION=${version}"
  ];

  meta = with lib; {
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
