{ lib, stdenv, nixosTests, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "agate";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "mbrubeck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NyHs/9kRBGqmh44MSRzYb7CSvEB0RlmL9l5QpGEwDhY=";
  };
  cargoSha256 = "sha256-V0MLXOLLmKnk4Iyhbu+EomsxOX6RLYHIsi/IwWiqmcg=";

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
