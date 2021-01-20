{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-protobuf";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "1kf1d7xmyjvy0z6j5czp6nqyvj9zrk6liv6znif08927xqfrzyln";
  };

  vendorSha256 = "04w9vhkrwb2zfqk73xmhignjyvjqmz1j93slkqp7v8jj2dhyla54";

  doCheck = false;

  meta = with stdenv.lib; {
    homepage    = "https://github.com/golang/protobuf";
    description = " Go bindings for protocol buffer";
    maintainers = with maintainers; [ lewo ];
    license     = licenses.bsd3;
    platforms   = platforms.unix;
  };
}
