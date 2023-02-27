{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
}:

rustPlatform.buildRustPackage rec {
  pname = "codevis";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "sloganking";
    repo = "codevis";
    rev = "v${version}";
    hash = "sha256-iw5ULK67AHLoffveZghk57lPQwE2oX+iwlO0dmdpE4E=";
  };

  cargoHash = "sha256-IxQ8rnB+2xTBiFvxy2yo27HtBu0zLvbQzyoxH/4waxQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  RUSTONIG_SYSTEM_LIBONIG = true;

  meta = with lib; {
    description = "A tool to take all source code in a folder and render them to one image";
    homepage = "https://github.com/sloganking/codevis";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
