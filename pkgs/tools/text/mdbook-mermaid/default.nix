{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-hqz2zUdDZjbe3nq4YpL68XJ64qpbjANag9S2uAM5nXg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yb4EWSl/mQp5q9fmYUq6UEdsknqfUx//BZ8IK/BVs7g=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreServices
  ];

  meta = with lib; {
    description = "Preprocessor for mdbook to add mermaid.js support";
    mainProgram = "mdbook-mermaid";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    changelog = "https://github.com/badboy/mdbook-mermaid/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      xrelkd
      matthiasbeyer
    ];
  };
}
