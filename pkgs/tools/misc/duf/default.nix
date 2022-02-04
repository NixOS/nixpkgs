{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "duf";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "sha256-FZ4NplvCc1c+wPy1NSs2qwfWVtCPNHs6JquubGnwiEY=";
  };

  vendorSha256 = "sha256-VLGsfazTD7hSNXPxuGJJwyqvUlqk5wuz8NqFHs/jyZc=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ petabyteboy penguwin SuperSandro2000 ];
  };
}
