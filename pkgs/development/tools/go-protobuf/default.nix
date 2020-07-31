{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-protobuf";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "0m5z81im4nsyfgarjhppayk4hqnrwswr3nix9mj8pff8x9jvcjqw";
  };

  vendorSha256 = "04w9vhkrwb2zfqk73xmhignjyvjqmz1j93slkqp7v8jj2dhyla54";

  meta = with stdenv.lib; {
    homepage    = "https://github.com/golang/protobuf";
    description = " Go bindings for protocol buffer";
    maintainers = with maintainers; [ lewo ];
    license     = licenses.bsd3;
    platforms   = platforms.unix;
  };
}
