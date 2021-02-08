{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "agate";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "mbrubeck";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rwoEZnxh0x+xaggJuoeSjE1ctF43ChW5awcDJyoWioA=";
  };

  cargoSha256 = "sha256-ey/fUHkPoWjWlLjh1WNpwMKOkdQKgFYcLwQdx2RQ3CI=";

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
