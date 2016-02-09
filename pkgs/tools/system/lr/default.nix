{ stdenv, fetchFromGitHub }:

let
  version = "0.2";
in
stdenv.mkDerivation {
  name = "lr-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "1wn1j0cf84r4nli92myf3waackh2p6r2hkavgx6533x15kdyfnf7";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    homepage = "http://github.com/chneukirchen/lr";
    description = "List files recursively";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [stdenv.lib.maintainers.globin];
  };
}
