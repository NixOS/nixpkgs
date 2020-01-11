{ fetchFromGitHub }:

rec {
  version = "4.0.5";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "v${version}";
    sha256 = "0zfda8mbcg4mgg39shxdx5n2bq6zi9w3v8bcx03b3dp09lmq45y3";
  };
}
