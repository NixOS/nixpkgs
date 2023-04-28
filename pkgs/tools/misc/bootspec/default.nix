{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "bootspec";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Gf6cIFympRIZo6vzQIX3sQ3ycLlmkDRXtEd2IYH7LQo=";
  };

  cargoHash = "sha256-8qm9aUvH1EbZ5Jmtw+86KdNyLbYJ7BVExTyyexirTyw=";

  meta = with lib; {
    description = "Implementation of RFC-0125's datatype and synthesis tooling";
    homepage = "https://github.com/DeterminateSystems/bootspec";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
    platforms = platforms.unix;
  };
}
