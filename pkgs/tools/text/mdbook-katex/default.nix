{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.5.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-RDNZ6+d+UbiQ/Eb2+YbhPyGVcM8079UFsnNvch/1oAs=";
  };

  cargoHash = "sha256-An2mQ4kWGF3qk2v9VeQh700n7n/+3ShPqMfCnZmiIuc=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time.";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
