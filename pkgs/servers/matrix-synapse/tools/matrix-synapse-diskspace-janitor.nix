{ lib, buildGoModule, fetchFromGitea }:

buildGoModule rec {
  pname = "matrix-synapse-diskspace-janitor";
  version = "unstable-2023-01-16";

  src = fetchFromGitea {
    domain = "git.cyberia.club";
    owner = "cyberia";
    repo = "matrix-synapse-diskspace-janitor";
    rev = "7c9297931104d31c4fc9740d32dfce7b8262a189";
    sha256 = "sha256-rsSJsvBbz8yJ+AcSInUxGN660WUrHicslwv4NU+1M9I=";
  };

  vendorHash = "sha256-oxEzqqKU/pCbt9i6M4nirCjo6T9UZTiknoo9CigbO1I=";

  # Note there is a systemd service included in the upstream repository, but it
  # assumes too many things about the system environment to meaningfully include
  # in this package.

  meta = with lib; {
    description = "A program designed to fix the disk-space consumption issues that matrix-synapse continues to suffer";
    homepage = "https://git.cyberia.club/cyberia/matrix-synapse-diskspace-janitor";
    license = licenses.mit;
    maintainers = with maintainers; [ ckie ];
  };
}
