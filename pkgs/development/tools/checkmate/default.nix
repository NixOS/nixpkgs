{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RCGJ7Xa5HLzcngv79NyocbNGoYZMAKyv/svRScM1vq0=";
  };

  vendorSha256 = "sha256-ZURtNED8gb0QsuXxJd9oBSx68ABcwlvVpkbd7lhiA9s=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
