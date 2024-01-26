{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JntFXpB72vZJHkyawFruLhz9rnR1fp+hoXEljzeV0Xo=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-IUJbatLE97qtUnm/Ho6SS+yL7LRd7oEGiSsZF36Qe5I=";

  meta = with lib; {
    description = "An extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}
