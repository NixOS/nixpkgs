{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mkcert";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FMAXjRL+kJ/hwGmaWBy8ecON+JCMgRytfpryeLWsSVc=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-DdA7s+N5S1ivwUgZ+M2W/HCp/7neeoqRQL0umn3m6Do=";
=======
  vendorSha256 = "sha256-DdA7s+N5S1ivwUgZ+M2W/HCp/7neeoqRQL0umn3m6Do=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [
    "-s" "-w" "-X main.Version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/FiloSottile/mkcert";
    description = "A simple tool for making locally-trusted development certificates";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
