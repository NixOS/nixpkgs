{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "duplicacy";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "gilbertchen";
    repo = "duplicacy";
    rev = "v${version}";
    sha256 = "sha256-7VCgXUmmAlmv0UwSM3Hs9t586gJWvFWsP/0BJXze1r4=";
  };

  vendorSha256 = "sha256-3vzx2SCgJAhSwW8DRtkQ6pywquFwwou0HZ6a1dmHhPY=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://duplicacy.com";
    description = "A new generation cloud backup tool";
    platforms = platforms.linux ++ platforms.darwin;
    license = lib.licenses.unfree;
    maintainers = with maintainers; [ ffinkdevs devusb ];
  };
}
