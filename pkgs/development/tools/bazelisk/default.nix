{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "philwo";
    repo = pname;
    rev = "v${version}";
    sha256 = "177x0mal960gs8578h5ir51vgn1bndm9z091110gqxb9xs9jq8pf";
  };

  modSha256 = "1f73j6ryidzi3kfy3rhsqx047vzwvzaqcsl7ykhg87rn2l2s7fdl";

  meta = with stdenv.lib; {
    description = "A user-friendly launcher for Bazel";
    homepage = https://github.com/philwo/bazelisk;
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
  };
}
