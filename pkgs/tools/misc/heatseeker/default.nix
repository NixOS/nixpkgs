{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "heatseeker-${version}";
  version = "1.3.0";

  depsSha256 = "03jap7myf85xgx9270sws8x57nl04a1wx8szrk9qx24s9vnnjcnh";

  src = fetchFromGitHub {
    owner = "rschmitt";
    repo = "heatseeker";
    rev = "v${version}";
    sha256 = "1xdvwgmh9lwv82hv1qg82bjv2iplnvva6lzbg7dyhbszhv7rhkbl";
  };
  
  # some tests require a tty, this variable turns them off for Travis CI,
  # which we can also make use of
  TRAVIS= "true";

  meta = with stdenv.lib; {
    description = "A general-purpose fuzzy selector";
    homepage = https://github.com/rschmitt/heatseeker;
    license = stdenv.lib.licenses.mit;
    maintainers = [ maintainers.michaelpj ];
  };
}
