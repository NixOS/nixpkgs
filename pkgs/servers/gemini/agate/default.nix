{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "agate";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "mbrubeck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EhIBkAPy+sZ629yxJ8GCVhEQx7gQypMFYquGpQJkke0=";
  };

  cargoSha256 = "sha256-nRrFC/6CgXZR78aJQVw2y2sKUmRpz8Rofo0N4vgeekg=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/agate --help
    $out/bin/agate --version 2>&1 | grep "agate ${version}"
    runHook postInstallCheck
  '';

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
