{ stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  name = "wabt-${version}";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner  = "WebAssembly";
    repo   = "wabt";
    rev    = version;
    sha256 = "018sb7p8xlvv8p2fdbnl0v98zh78zc8ha74ldw5c8z0i7xzgzj9w";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ "-DBUILD_TESTS=OFF" ];
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
    homepage = https://github.com/WebAssembly/wabt;
    license = licenses.asl20;
    maintainers = with maintainers; [ ekleog ];
    platforms = platforms.unix;
  };
}
