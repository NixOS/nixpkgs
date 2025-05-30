{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "bore-cli";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "bore";
    rev = "v${version}";
    hash = "sha256-jQeSwzlMJsZz80SAb/HN4Xyazd50VIxly8K7kSOcLPU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uaSnH3pLpgASjauNWE94cpLxeAmVPqa/VUksR12hnGM=";

  # tests do not find grcov path correctly
  meta = with lib; {
    description = "Rust tool to create TCP tunnels";
    homepage = "https://github.com/ekzhang/bore";
    license = licenses.mit;
    maintainers = with maintainers; [ DieracDelta ];
    mainProgram = "bore";
  };
}
