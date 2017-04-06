{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "heatseeker-${version}";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "rschmitt";
    repo = "heatseeker";
    rev = "v${version}";
    sha256 = "1fcrbjwnhcz71i70ppy0rcgk5crwwmbkm9nrk1kapvks33pv0az7";
  };

  depsSha256 = "05mj84a5k65ai492grwg03c3wq6ardhs114bv951fgysc9rs07p5";

  # some tests require a tty, this variable turns them off for Travis CI,
  # which we can also make use of
  TRAVIS = "true";

  meta = with stdenv.lib; {
    description = "A general-purpose fuzzy selector";
    homepage = https://github.com/rschmitt/heatseeker;
    license = licenses.mit;
    maintainers = [ maintainers.michaelpj ];
    platforms = platforms.linux;
  };
}
