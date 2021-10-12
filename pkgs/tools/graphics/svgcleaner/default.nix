{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "svgcleaner";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "svgcleaner";
    rev = "v${version}";
    sha256 = "sha256-nc+lKL6CJZid0WidcBwILhn81VgmmFrutfKT5UffdHA=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock;
  '';

  meta = with lib; {
    description = "A tool for tidying and optimizing SVGs";
    homepage = "https://github.com/RazrFalcon/svgcleaner";
    changelog = "https://github.com/RazrFalcon/svgcleaner/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mehandes ];
  };
}
