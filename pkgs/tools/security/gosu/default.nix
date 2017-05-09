{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gosu-${version}";
  version = "1.10";

  goPackagePath = "github.com/tianon/gosu";

  src = fetchFromGitHub {
    owner = "tianon";
    repo = "gosu";
    rev = version;
    sha256 = "074md9gzsmydcrzh8fq9l4pmk9d1y5sdkwjpsgxca77ns2bi4wv9";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Simple Go-based setuid+setgid+setgroups+exec";
    homepage    = "https://github.com/tianon/gosu";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
