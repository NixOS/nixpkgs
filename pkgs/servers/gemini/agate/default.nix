{ lib, stdenv, nixosTests, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "agate";
  version = "3.3.4";

  src = fetchFromGitHub {
    owner = "mbrubeck";
    repo = "agate";
    rev = "v${version}";
    hash = "sha256-7z3iAA+Q3k5jEO9ZhA06h7/17gE0FWPqDOGK/XENRWg=";
  };

  cargoHash = "sha256-iTopJnuH2extGnaJXL+RPUwcvj2e+k5A4BT33v+sFiA=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/agate --help
    $out/bin/agate --version 2>&1 | grep "agate ${version}"
    runHook postInstallCheck
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests = { inherit (nixosTests) agate; };

  meta = with lib; {
    homepage = "https://github.com/mbrubeck/agate";
    changelog = "https://github.com/mbrubeck/agate/blob/master/CHANGELOG.md";
    description = "Very simple server for the Gemini hypertext protocol";
    mainProgram = "agate";
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
