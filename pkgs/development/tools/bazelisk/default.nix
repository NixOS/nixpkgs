{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "philwo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hi4jmkqy1fjn91q72qlfvm63plz5jqb4hw4c1qv9ddqjgwrmxr3";
  };

  modSha256 = "1f73j6ryidzi3kfy3rhsqx047vzwvzaqcsl7ykhg87rn2l2s7fdl";

  meta = with stdenv.lib; {
    description = "A user-friendly launcher for Bazel";
    homepage = https://github.com/philwo/bazelisk;
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
  };
}
