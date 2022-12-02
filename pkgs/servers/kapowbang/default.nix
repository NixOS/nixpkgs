{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kapowbang";
  version = "0.7.0";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "BBVA";
    repo = "kapow";
    rev = "v${version}";
    sha256 = "sha256-0ftdc3ol1g0WnZgicXl46Xpph4cUYk/G/eeu+9JnPyA=";
  };

  vendorSha256 = "sha256-41Jk3aTe4EA5dwkriEo48QNJg2k3T/R/8i8XWcURcG8=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/BBVA/kapow";
    description = "Expose command-line tools over HTTP";
    license = licenses.asl20;
    maintainers = with maintainers; [ nilp0inter ];
    mainProgram = "kapow";
  };
}
