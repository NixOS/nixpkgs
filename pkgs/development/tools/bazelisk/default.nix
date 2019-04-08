{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "philwo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rkpw9izpav3ysb9fpbdf0m1wqrs3vl87s9zjjmfsjm5dfhxss72";
  };

  modSha256 = "1f73j6ryidzi3kfy3rhsqx047vzwvzaqcsl7ykhg87rn2l2s7fdl";

  meta = with stdenv.lib; {
    description = "A user-friendly launcher for Bazel";
    homepage = https://github.com/philwo/bazelisk;
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
  };
}
