{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
, makeWrapper
, typst
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-live";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-8YndEqhIESC3Cbe4klQfkVqesNFeZ2g1oRd1VoVrMnE=";
  };

  cargoHash = "sha256-62tBefXek6W01RfdPczXBuYhrLK+wG1YQ7va7FQmAhA=";

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
    mainProgram = "typst-live";
  };
}
