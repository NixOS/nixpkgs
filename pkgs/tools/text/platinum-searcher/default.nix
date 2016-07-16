{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "the_platinum_searcher-${version}";
  version = "2.1.3";
  rev = "v2.1.3";

  goPackagePath = "github.com/monochromegane/the_platinum_searcher";

  src = fetchFromGitHub {
    inherit rev;
    owner = "monochromegane";
    repo = "the_platinum_searcher";
    sha256 = "09pkdfh7fqn3x4l9zaw5wzk20k7nfdwry7br9vfy3vv3fwv61ynp";
  };

  goDeps = ./deps.json;

  meta = with stdenv.lib; {
    homepage = https://github.com/monochromegane/the_platinum_searcher;
    description = "A code search tool similar to ack and the_silver_searcher(ag).";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
