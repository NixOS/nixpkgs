{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "ctop-unstable-${version}";
  version = "2017-05-28";
  rev = "b4e1fbf29073625ec803025158636bdbcf2357f4";

  goPackagePath = "github.com/bcicen/ctop";

  src = fetchFromGitHub {
    inherit rev;
    owner = "bcicen";
    repo = "ctop";
    sha256 = "162pc7gds66cgznqlq9gywr0qij5pymn7xszlq9rn4w2fm64qgg3";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Concise commandline monitoring for containers";
    homepage = "http://ctop.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
