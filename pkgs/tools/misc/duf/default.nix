{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "duf";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "sha256-Uv7c4OhY+pblivypJBqSh/az3d5WybcOckB4HvO9/+s=";
  };

  vendorSha256 = "sha256-A1rUC1dnlm3gZYjnwA/XQONSgaVjebFJfP2U5r2No94=";

  buildFlagsArray = [ "-ldflags=-s -w -X=main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ petabyteboy penguwin SuperSandro2000 ];
  };
}
