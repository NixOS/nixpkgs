{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "heatseeker-${version}";
  version = "1.5.0";

  depsSha256 = "0rv622rli3prsk6vizv9xw50mf5ihb4an9v72rcb7fcxyvh66qnj";

  src = fetchFromGitHub {
    owner = "rschmitt";
    repo = "heatseeker";
    rev = "v${version}";
    sha256 = "0h6ny0wdrqm583b36393xwsh8wlwhl8ddyjxcgk84p7lyabj9zky";
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
