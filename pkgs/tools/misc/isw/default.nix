{
  lib,
  fetchFromGitLab,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "isw";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "thom-cameron";
    repo = "isw";
    rev = version;
    hash = "sha256-1gbh5Bfv/HW+UmHgdLScodPBY4qoOTJtJwMdkOk9/v4=";
  };

  cargoHash = "sha256-LpKiP7bwiNEUXYvQsUG//wqOwGmg2UD3DA0Gb2h7kMw=";

  meta = {
    description = "Simple terminal stopwatch application";
    homepage = "https://gitlab.com/thom-cameron/isw";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ thom-cameron ];
  };
}
