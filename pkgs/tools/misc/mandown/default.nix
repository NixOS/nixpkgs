{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "mandown";
  version = "0.1.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-8a4sImsjw+lzeVK4V74VpIKDcAhMR1bOmJYVWzfWEfc=";
  };

  cargoHash = "sha256-Wf1+dxwgPZ4CHpas+3P6n6kKDIISbnfI01+XksjxQlQ=";

  meta = with lib; {
    description = "Markdown to groff (man page) converter";
    homepage = "https://gitlab.com/kornelski/mandown";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ];
    mainProgram = "mandown";
  };
}
