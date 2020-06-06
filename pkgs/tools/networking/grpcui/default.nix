{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grpcui";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dcah6bamjqyp9354qrd1cykdr5k5l93hh7qcy5b4nkag9531gl0";
  };

  vendorSha256 = "0m9nn8x0ji0n9v3d5w5z3grwv0zh8ijvh92jqjpcfv4bcjr5vsjr";

  meta = with lib; {
    description = "An interactive web UI for gRPC, along the lines of postman";
    homepage = "https://github.com/fullstorydev/grpcui";
    license = licenses.mit;
    maintainers = with maintainers; [ pradyuman ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}