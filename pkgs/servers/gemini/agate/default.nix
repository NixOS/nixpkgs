{ lib, stdenv, nixosTests, fetchFromGitHub, fetchpatch, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "agate";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "mbrubeck";
    repo = "agate";
    rev = "v${version}";
    hash = "sha256-qINtAOPrmLUWfEjZNj11W2WoIFw7Ye3KDk+9ZKtZAvo=";
  };

  cargoPatches = [
    # Update version in Cargo.lock
    (fetchpatch {
      url = "https://github.com/mbrubeck/agate/commit/ac57093d2f73a20d0d4f84b551beef4ac9cb4a24.patch";
      hash = "sha256-OknfBkaBWm3svSp8LSvyfy2g0y0SkR7VtJQUdAjClFs=";
    })
  ];

  cargoHash = "sha256-18V1/d2A3DJmpYX/5Z8M3uAaHrULGIgCT4ntcV4N8l0=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/agate --help
    $out/bin/agate --version 2>&1 | grep "agate ${version}"
    runHook postInstallCheck
  '';

  passthru.tests = { inherit (nixosTests) agate; };

  meta = with lib; {
    homepage = "https://github.com/mbrubeck/agate";
    changelog = "https://github.com/mbrubeck/agate/blob/master/CHANGELOG.md";
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
