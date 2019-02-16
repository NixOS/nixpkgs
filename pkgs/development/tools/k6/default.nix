{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage  rec {
  name = "k6-${version}";
  version = "0.23.1";

  goPackagePath = "github.com/loadimpact/k6";

  src = fetchFromGitHub {
    owner = "loadimpact";
    repo = "k6";
    rev = "v${version}";
    sha256 = "03krrpbb67h9hmrg5m94936kha667yh2lqzp9s7fv0b6khskr9r7";
  };

  subPackages = [ "./" ];

  meta = with stdenv.lib; {
    homepage = https://k6.io/;
    description = "A modern load testing tool, using Go and JavaScript";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ offline ];
  };
}
