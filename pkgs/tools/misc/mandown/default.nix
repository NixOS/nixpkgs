{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "mandown";
  version = "0.1.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-8SHZR8frDHLGj2WYlnFGBWY3B6xv4jByET7CODt2TGw=";
  };

  cargoHash = "sha256-/IvPvJo5zwvLY+P5+hsdbR56/pfopfwncEz9UGUS1Oc=";

  meta = with lib; {
    description = "Markdown to groff (man page) converter";
    homepage = "https://gitlab.com/kornelski/mandown";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ];
    mainProgram = "mandown";
  };
}
