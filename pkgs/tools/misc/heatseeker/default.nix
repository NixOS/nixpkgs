{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  pname = "heatseeker";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "rschmitt";
    repo = "heatseeker";
    rev = "v${version}";
    sha256 = "1fcrbjwnhcz71i70ppy0rcgk5crwwmbkm9nrk1kapvks33pv0az7";
  };

  cargoSha256 = "0m3sxbz1iii31s30cnv1970i1mwfhl6gm19k8wv0n7zji30ayx07";

  # some tests require a tty, this variable turns them off for Travis CI,
  # which we can also make use of
  TRAVIS = "true";

  meta = with stdenv.lib; {
    description = "A general-purpose fuzzy selector";
    homepage = https://github.com/rschmitt/heatseeker;
    license = licenses.mit;
    maintainers = [ maintainers.michaelpj ];
    platforms = platforms.unix;
  };
}
