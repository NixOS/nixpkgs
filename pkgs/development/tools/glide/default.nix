{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "glide-${version}";
  version = "0.12.3";

  goPackagePath = "github.com/Masterminds/glide";

   buildFlagsArray = ''
   -ldflags=
      -X main.version=${version}
  '';

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Masterminds";
    repo = "glide";
    sha256 = "0hvfikvxfk94aqms1bdxqxqpamzy0v8binv5jwglzw2sf2437ww0";
  };

  meta = with stdenv.lib; {
    homepage = https://glide.sh;
    description = "Package management for Go";
    license = licenses.mit;
    maintainers = [ maintainers.rushmorem ];
  };
}
