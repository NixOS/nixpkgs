{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "cod";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "dim-an";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wi680sxpv0kp1ggy21qp4c4ms79hw4z9w9kvp278p8z3y8wwglr";
  };

  vendorSha256 = "1arllkiz1hk12hq5b2zpg3f8i9lxl66mil5sdv8gnhflmb37vbv3";

  buildFlagsArray = [ "-ldflags=-s -w -X main.GitSha=${src.rev}" ];

  doCheck = false;

  meta = with lib; {
    description = "Tool for generating Bash/Fish/Zsh autocompletions based on `--help` output";
    homepage = src.meta.homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
