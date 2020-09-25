{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "k6";
  version = "0.28.0";

  goPackagePath = "github.com/loadimpact/k6";

  src = fetchFromGitHub {
    owner = "loadimpact";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zpkavl6sg6kcb7wc92lzi4svvv3284xs20zbmgq4i9i5z1njdkx";
  };

  subPackages = [ "./" ];

  meta = with stdenv.lib; {
    description = "A modern load testing tool, using Go and JavaScript";
    homepage = "https://k6.io/";
    changelog = "https://github.com/loadimpact/k6/releases/tag/v${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ offline ];
  };
}
