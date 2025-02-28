{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tremor-language-server";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "tremor-rs";
    repo = "tremor-language-server";
    rev = "v${version}";
    sha256 = "sha256-odYhpb3FkbIF1dc2DSpz3Lg+r39lhDKml9KGmbqJAtA=";
  };

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-Hl0TY/xZaDybYjrGiRftZhFx8dns+ONuNcxzl8lBUMM=";

  meta = with lib; {
    description = "Tremor Language Server (Trill)";
    homepage = "https://www.tremor.rs/docs/next/getting-started/tooling";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
