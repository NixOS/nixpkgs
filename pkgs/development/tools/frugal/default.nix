{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.14.4";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RFVn5aL5MqsB7heDPVUci3Eyq6F/qo3RmdEaZbsC+Ng=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-hyupBMRKuw77SJNIk3mEUixV0LV5mEmZx8M70qGmYJY=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}
