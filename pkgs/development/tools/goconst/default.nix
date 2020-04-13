{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "goconst";
  version = "1.1.0";

  goPackagePath = "github.com/jgautheron/goconst";
  excludedPackages = ''testdata'';

  src = fetchFromGitHub {
    owner = "jgautheron";
    repo = "goconst";
    rev = version;
    sha256 = "0zhscvv9w54q1h2vs8xx3qkz98cf36qhxjvdq0xyz3qvn4vhnyw6";
  };

  meta = with lib; {
    description = "Find in Go repeated strings that could be replaced by a constant";
    homepage = "https://github.com/jgautheron/goconst";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
