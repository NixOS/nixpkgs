{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "jd-${version}";
  version = "0.3.1";
  rev = "2729b5af166cfd72bd953ef8959b456c4db940fc";

  goPackagePath = "github.com/tidwall/jd";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/tidwall/jd";
    sha256 = "0dj4k38pf80dl77jns29vx2dj265s4ksg2q2s9n240b7b8z8mn5h";
  };

  meta = with stdenv.lib; {
    description = "Interactive JSON Editor";
    license = licenses.mit;
    maintainers = [ maintainers.np ];
  };
}
