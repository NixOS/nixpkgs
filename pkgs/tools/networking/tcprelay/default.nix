{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "tcprelay";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "overhead";
    repo = "tcp-relay";
    rev = "v${version}";
    hash = "sha256-CzaZycn6Z9wVIQ2GNX7MN8SJt17ANMmh4meeOl1yKMM=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "TCP relay written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ shutdaun ];
    mainProgram = "tcprelay";
    platforms = platforms.all;
  };
}
