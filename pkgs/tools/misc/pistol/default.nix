{ lib
, buildGoModule
, fetchFromGitHub
, file
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-c85XF1Glg6A7utPfXOv4LBesJy9+ErE2B+DO243mMhg=";
  };

  vendorSha256 = "sha256-n98cjXsgg2w3shbZPnk3g7mBbzV5Tc3jd9ZtiRk1KUM=";

  doCheck = false;

  subPackages = [ "cmd/pistol" ];

  buildInputs = [
    file
  ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version}" ];

  meta = with lib; {
    description = "General purpose file previewer designed for Ranger, Lf to make scope.sh redundant";
    homepage = "https://github.com/doronbehar/pistol";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
