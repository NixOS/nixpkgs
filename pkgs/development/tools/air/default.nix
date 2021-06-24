{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.25";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
    sha256 = "sha256-on9Rb+QGFWx7/k9xD+tcaPu6YNaBBkFBHHMSWJbZpWM=";
  };

  vendorSha256 = "sha256-B7AgUFjiW3P1dU88u3kswbCQJ7Qq7rgPlX+b+3Pq1L4=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/cosmtrek/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
