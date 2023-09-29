{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "deadcode";
  version = "unstable-2019-04-27";

  src = fetchFromGitHub {
    owner = "remyoudompheng";
    repo = "go-misc";
    rev = "2d6ac652a50e368c874b15d00ea5e346e240e906";
    hash = "sha256-Kp6AlV86KjZARaxO9zcfIdT/zjZch5P3Nzmo/d36dBI=";
  };

  vendorHash = "sha256-/Mnt7JeLoFiIBxQ/5zqTzea+CHaV7YXKPIA6BECmOdg=";

  preBuild = ''
    # Fix outdated go.mod & go.sum
    cp ${./go.mod} go.mod
    cp ${./go.sum} go.sum
  '';

  subPackages = [ "deadcode" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Very simple utility which detects unused declarations in a Go package";
    homepage = "https://github.com/remyoudompheng/go-misc/tree/master/deadcode";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
  };
}
