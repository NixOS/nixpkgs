{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "go-protobuf-${version}";
  version = "2018-01-04";
  rev = "1e59b77b52bf8e4b449a57e6f79f21226d571845";

  goPackagePath = "github.com/golang/protobuf";

  src = fetchFromGitHub {
    inherit rev;
    owner = "golang";
    repo = "protobuf";
    sha256 = "19bkh81wnp6njg3931wky6hsnnl2d1ig20vfjxpv450sd3k6yys8";
  };

  meta = with stdenv.lib; {
    homepage    = "https://github.com/golang/protobuf";
    description = " Go bindings for protocol buffer";
    maintainers = with maintainers; [ lewo ];
    license     = licenses.bsd3;
    platforms   = platforms.unix;
  };
}
