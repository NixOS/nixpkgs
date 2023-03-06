{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VSIeEyMFY10aHLCRmTh0EaGa08KPqrStsPLrssDT0TE=";
  };

  cargoHash = "sha256-0kDRrsiGJw4iv4CD3FRE4zIBfGO352vnp2KD1RiZafg=";

  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
    mainProgram = "et";
  };
}
