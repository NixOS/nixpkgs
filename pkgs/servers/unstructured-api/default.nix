{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  makeWrapper,
  nix-update-script,
  symlinkJoin,
  nltk-data,
}:
let
  pythonEnv = python3.withPackages (packages: with packages; [
    unstructured-api-tools
    unstructured
    pydantic
    click
    ratelimit
    requests
    pypdf
    pycryptodome
    safetensors
    uvicorn
  ] ++ packages.unstructured.optional-dependencies.local-inference);
  version = "0.0.39";
  unstructured_api_nltk_data = symlinkJoin {
    name = "unstructured_api_nltk_data";

    paths = [ nltk-data.punkt nltk-data.averaged_perceptron_tagger ];
  };
in stdenvNoCC.mkDerivation {
  pname = "unstructured-api";
  inherit version;

  src = fetchFromGitHub {
    owner = "Unstructured-IO";
    repo = "unstructured-api";
    rev = version;
    hash = "sha256-fk0YkGllggi0eWdp9ytHy4/9rChkcDnQvEvVAp1+RJw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out $out/bin $out/lib
    cp -r . $out/lib

    makeWrapper ${pythonEnv}/bin/uvicorn $out/bin/unstructured-api \
      --set NLTK_DATA ${unstructured_api_nltk_data} \
      --prefix PYTHONPATH : $out/lib \
      --add-flags "prepline_general.api.app:app"

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "open-source toolkit designed to make it easy to prepare unstructured data like PDFs, HTML and Word Documents for downstream data science tasks";
    homepage = "https://github.com/Unstructured-IO/unstructured-api";
    changelog = "https://github.com/Unstructured-IO/unstructured-api/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
