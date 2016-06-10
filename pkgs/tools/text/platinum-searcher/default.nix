{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "the_platinum_searcher-${version}";
  version = "2.1.1";
  rev = "v2.1.1";

  goPackagePath = "github.com/monochromegane/the_platinum_searcher";

  src = fetchFromGitHub {
    inherit rev;
    owner = "monochromegane";
    repo = "the_platinum_searcher";
    sha256 = "06cs936w3l64ikszcysdm9ijn52kwgi1ffjxkricxbdb677gsk23";
  };

  goDeps = ./deps.json;

  meta = with stdenv.lib; {
    homepage = https://github.com/monochromegane/the_platinum_searcher;
    description = "A code search tool similar to ack and the_silver_searcher(ag).";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
