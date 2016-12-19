{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "heatseeker-${version}";
  version = "1.4.0";

  depsSha256 = "1acimdkl6ra9jlyiydzzd6ccdygr5is2xf9gw8i45xzh0xnsq226";

  src = fetchFromGitHub {
    owner = "rschmitt";
    repo = "heatseeker";
    rev = "v${version}";
    sha256 = "1v2p6l4bdmvn9jggb12p0j5ajjvnbcdjsiavlcqiijz2w8wcdgs8";
  };

  # some tests require a tty, this variable turns them off for Travis CI,
  # which we can also make use of
  TRAVIS= "true";

  meta = with stdenv.lib; {
    description = "A general-purpose fuzzy selector";
    homepage = https://github.com/rschmitt/heatseeker;
    license = stdenv.lib.licenses.mit;
    maintainers = [ maintainers.michaelpj ];
    platforms = platforms.linux;
  };
}
