{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gotty";
  version = "2.0.0-alpha.3";
  rev = "v${version}";

  goPackagePath = "github.com/yudai/gotty";

  src = fetchFromGitHub {
    inherit rev;
    owner = "yudai";
    repo = "gotty";
    sha256 = "1vhhs7d4k1vpkf2k69ai2r3bp3zwnwa8l9q7vza0rck69g4nmz7a";
  };

  meta = with stdenv.lib; {
    description = "Share your terminal as a web application";
    homepage = https://github.com/yudai/gotty;
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
