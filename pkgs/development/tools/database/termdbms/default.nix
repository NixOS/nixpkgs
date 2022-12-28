{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "termdbms";
  version = "unstable-2021-09-04";

  src = fetchFromGitHub {
    owner = "mathaou";
    repo = "termdbms";
    rev = "d46e72c796e8aee0def71b8e3499b0ebe5ca3385";
    sha256 = "1c3xgidhmvlcdw7v5gcqzv27cb58f1ix8sfd4r14rfz7c8kbv37v";
  };

  vendorSha256 = "0h9aw68niizd9gs0i890g6ij13af04qgpfy1g5pskyr4ryx0gn26";

  patches = [ ./viewer.patch ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/mathaou/termdbms/";
    description = "A TUI for viewing and editing database files";
    license = licenses.mit;
    maintainers = with maintainers; [ izorkin ];
    mainProgram = "sqlite3-viewer";
  };
}
