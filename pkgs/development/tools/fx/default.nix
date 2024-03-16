{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fx";
  version = "33.0.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    hash = "sha256-RY/7EIsn4pQNlx9qp/ueeNSOEPbgUFsZRJ/Fn1EDJ74=";
  };

  vendorHash = "sha256-uKF6kNV2Rbgbtx5ePqxOuFisrxJXb/+qSuSMHK5jhWg=";

  meta = with lib; {
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    changelog = "https://github.com/antonmedv/fx/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
