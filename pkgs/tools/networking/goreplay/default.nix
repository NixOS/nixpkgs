{ lib, buildGoPackage, fetchFromGitHub, libpcap }:

buildGoPackage rec {
  pname = "goreplay";
  version = "1.1.0";
  rev = "v${version}";

  goPackagePath = "github.com/buger/goreplay";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "buger";
    repo   = "goreplay";
    sha256 = "07nsrx5hwmk6l8bqp48gqk40i9bxf0g4fbmpqbngx6j5f7lpbk2n";
  };

  buildInputs = [ libpcap ];

  meta = {
    homepage = "https://github.com/buger/goreplay";
    license = lib.licenses.lgpl3Only;
    description = "Open-source tool for capturing and replaying live HTTP traffic";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ lovek323 ];
  };
}
