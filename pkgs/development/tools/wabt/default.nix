{ stdenv, fetchpatch, fetchFromGitHub, cmake, python3, substituteAll }:

stdenv.mkDerivation rec {
  pname = "wabt";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wabt";
    rev = version;
    sha256 = "0zis0190zs37x1wq044qd2vyvzcrkm8kp0734byz1lpdlgl5257b";
    fetchSubmodules = true;
  };

  # https://github.com/WebAssembly/wabt/pull/1408
  patches = [ (fetchpatch {
    url = "https://github.com/WebAssembly/wabt/pull/1408/commits/9115d0c55067435ec9c55924e8a2bb151bac095d.patch";
    sha256 = "1iklbz630vih08brsgq2d5q91kialg255sgd1mxl7023pvrhi44g";
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
