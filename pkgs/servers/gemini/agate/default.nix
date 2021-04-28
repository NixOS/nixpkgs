{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "agate";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "mbrubeck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+X1ibnYAUB34u8+oNBSkjLtsArxlrg0Nq5zJrXi7Rfk=";
  };

  cargoSha256 = "sha256-EOxklOiazxhhIIv6c+N4uuItY/oFMAG0r/ATZ3Anlko=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  checkFlags = [
    # Username and Password use the same ports and causes collision
    # https://github.com/mbrubeck/agate/issues/50
    "--skip username"
    "--skip password"
  ];

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
