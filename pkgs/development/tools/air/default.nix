{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
    sha256 = "0d34k8hyag84j24bhax4gvg8mkzqyhdqd16rfirpfjiqvqh0vdkz";
  };

  vendorSha256 = "0k28rxnd0vyb6ljbi83bm1gl7j4r660a3ckjxnzc2qzwvfj69g53";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/cosmtrek/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
