{ stdenv, buildGoPackage, fetchgit, asciidoc, go-runewidth, pflag }:

buildGoPackage rec {
  name = "tewisay-${version}";
  version = "0.65+e3fc387";
  goPackagePath = "github.com/neeee/tewisay";

  src = fetchgit {
    url = https://github.com/lucy/tewisay.git;
    rev = "e3fc38737cedb79d93b8cee07207c6c86db4e488";
    sha256 = "1na3xi4z90v8qydcvd3454ia9jg7qhinciy6kvgyz61q837cw5dk";
  };

  meta = {
    description = "Cowsay replacement with unicode and partial ansi escape support";
    homepage = https://github.com/lucy/tewisay;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.rob ];
  };
}
