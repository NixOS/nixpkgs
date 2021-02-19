{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "agate";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "mbrubeck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IapgDqRZ7VMWerusWcv++Ky4yWgGLMaq8rFhbPshFjE=";
  };

  cargoSha256 = "sha256-+Ch6nEGxYm2L4S9FkIkenDQovMZvQUJGOu5mR9T8r/Y=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    homepage = "https://proxy.vulpes.one/gemini/qwertqwefsday.eu/agate.gmi";
    changelog = "https://proxy.vulpes.one/gemini/qwertqwefsday.eu/agate.gmi";
    description = "Very simple server for the Gemini hypertext protocol";
    longDescription = ''
      Agate is a server for the Gemini network protocol, built with the Rust
      programming language. Agate has very few features, and can only serve
      static files. It uses async I/O, and should be quite efficient even when
      running on low-end hardware and serving many concurrent requests.
    '';
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ jk ];
  };
}
