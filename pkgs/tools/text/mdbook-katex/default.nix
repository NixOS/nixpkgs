{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.9.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-O2hFv/9pqrs8cSDvHLAUnXx4mX6TN8hvPLroWgoCgwE=";
  };

  cargoHash = "sha256-ONZZ6D0Ien0wakjhy6P2lhx0AnRLH0xpuYon+N9Crg8=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Preprocessor for mdbook, rendering LaTeX equations to HTML at build time";
    mainProgram = "mdbook-katex";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [
      lovesegfault
      matthiasbeyer
    ];
  };
}
