{ lib, stdenv, nixosTests, fetchFromGitHub, fetchpatch, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "agate";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "mbrubeck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nkWk/0TIAHcYQjxbg0HnT+4S4Cinl22WfqHb9U6u5eI=";
  };
  cargoSha256 = "sha256-aF86QpizJ+lMNmN9DQKA9o1QZWZObyQ3v3+HmT/s02g=";

  patches = [
    # https://github.com/mbrubeck/agate/pull/143
    (fetchpatch {
      name = "fix-port-collision.patch";
      url = "https://github.com/mbrubeck/agate/commit/2f5d7878ec9d0dd51762c4c7680fc9f825d8ecd5.patch";
      sha256 = "sha256-NEFmfb0y97O2W96YggD+MgcN7tlFEi9T4FNzLCND77s=";
    })
  ];

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
