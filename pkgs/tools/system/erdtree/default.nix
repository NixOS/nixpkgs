{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xPMOjhp4voT2Ad30WtAyA0MT917xt3Sd++KhLHmciA0=";
  };

  cargoHash = "sha256-euthKq/5X5bCxV8qAAHyMm4nPPSWCvGRCfx0a1kwr/c=";

  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
    mainProgram = "et";
  };
}
