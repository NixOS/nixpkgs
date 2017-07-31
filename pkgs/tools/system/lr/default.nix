{ stdenv, fetchFromGitHub }:

let
  version = "0.3.2";
in
stdenv.mkDerivation {
  name = "lr-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "1bbgzshayk0kzmlyw44jqskgmxz5c4jh2h0bqg3n5zi89588ng2k";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    homepage = http://github.com/chneukirchen/lr;
    description = "List files recursively";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.globin ];
  };
}
