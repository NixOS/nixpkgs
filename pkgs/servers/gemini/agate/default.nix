{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "agate";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "mbrubeck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mnatEvojma1+cOVllTAzDVxl5luRGleLE6GNPnQUNWQ=";
  };

  cargoSha256 = "sha256-B07itUftDj3yVMDc/2VetwYs74fZBa1tmeELbbQ39P0=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    homepage = "https://proxy.vulpes.one/gemini/gem.limpet.net/agate";
    changelog = "https://proxy.vulpes.one/gemini/gem.limpet.net/agate";
    description = "Very simple server for the Gemini hypertext protocol";
    longDescription = ''
      Agate is a server for the Gemini network protocol, built with the Rust
      programming language. Agate has very few features, and can only serve
      static files. It uses async I/O, and should be quite efficient even when
      running on low-end hardware and serving many concurrent requests.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
