{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "pflag-${version}";
  version = "0.0.1+45c278a";
  goPackagePath = "github.com/ogier/pflag.git";

  src = fetchgit {
    url = "https://github.com/ogier/pflag.git";
    rev = "45c278ab3607870051a2ea9040bb85fcb8557481";
    sha256 = "0620v75wppfd84d95n312wpngcb73cph4q3ivs1h0waljfnsrd5l";
  };

  meta = {
    description = "Drop-in replacement for Go's flag package, implementing POSIX/GNU-style --flags";
    homepage = https://github.com/ogier/pflag;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.rob ];
  };
}
