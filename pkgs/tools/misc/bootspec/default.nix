{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "bootspec";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6hgC/bOtzmVu+/pSVMpW4IkwNNemI2k/ykzxCibQUok=";
  };

  cargoHash = "sha256-l9W7MzeL1kiTvNe7QbP2bt8vqbnGrqK44UTlRRNRcYw=";

  meta = with lib; {
    description = "Implementation of RFC-0125's datatype and synthesis tooling";
    homepage = "https://github.com/DeterminateSystems/bootspec";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
    platforms = platforms.unix;
  };
}
