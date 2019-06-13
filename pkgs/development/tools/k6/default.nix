{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "k6";
  version = "0.24.0";

  goPackagePath = "github.com/loadimpact/k6";

  src = fetchFromGitHub {
    owner = "loadimpact";
    repo = pname;
    rev = "v${version}";
    sha256 = "1riyyi4lxdaqilzzkxzzw3hzcrjjcylq2jh3p3656f99wiisvj28";
  };

  subPackages = [ "./" ];

  meta = with stdenv.lib; {
    homepage = https://k6.io/;
    description = "A modern load testing tool, using Go and JavaScript";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ offline ];
  };
}
