{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "go-protobuf-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "15am4s4646qy6iv0g3kkqq52rzykqjhm4bf08dk0fy2r58knpsyl";
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
