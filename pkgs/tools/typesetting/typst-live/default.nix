{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
, makeWrapper
, typst
}:

rustPlatform.buildRustPackage {
  pname = "typst-live";
  version = "unstable-2023-05-27";

  src = fetchFromGitHub {
    owner = "ItsEthra";
    repo = "typst-live";
    rev = "10a2da57b93f8d6e4eaa0bfcec1e68e46b916868";
    hash = "sha256-42QzqbyIjPn0C4coCU81gtlI7v5XJStlsDZvnLlwpYs=";
  };

  cargoHash = "sha256-M5jYSLw5oquAq2gGWZOJvx5/CGAl2Rg+G94V6ivAOzc=";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  postInstall = ''
    wrapProgram $out/bin/typst-live \
      --suffix PATH : ${lib.makeBinPath [ typst ]}
  '';

  meta = with lib; {
    description = "Hot reloading for your typst files";
    homepage = "https://github.com/ItsEthra/typst-live";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
