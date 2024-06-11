{ rustPlatform, lib, fetchFromGitLab }:

rustPlatform.buildRustPackage rec {
  pname = "uwc";
  version = "1.0.5";

  src = fetchFromGitLab {
    owner = "dead10ck";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-x2mijB1GkxdraFroG1+PiBzWKPjsaAeoDt0HFL2v93I=";
  };

  cargoHash = "sha256-0IvOaQaXfdEz5tlXh5gTbnZG9QZSWDVHGOqYq8aWOIc=";

  doCheck = true;

  meta = with lib; {
    description = "Like wc, but unicode-aware, and with per-line mode";
    mainProgram = "uwc";
    homepage = "https://gitlab.com/dead10ck/uwc";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
