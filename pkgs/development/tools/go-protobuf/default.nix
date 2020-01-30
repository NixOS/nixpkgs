{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-protobuf";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "1cyyr52yhj3fzrily3rmsbqyj8va4ld75lmry0857m39rgpv8sy1";
  };

  modSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  meta = with stdenv.lib; {
    homepage    = "https://github.com/golang/protobuf";
    description = " Go bindings for protocol buffer";
    maintainers = with maintainers; [ lewo ];
    license     = licenses.bsd3;
    platforms   = platforms.unix;
  };
}
