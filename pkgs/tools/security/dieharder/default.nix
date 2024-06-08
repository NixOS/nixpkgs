{ lib, stdenv, fetchurl, gsl
, dieharder, testers }:

stdenv.mkDerivation rec {
  pname = "dieharder";
  version = "3.31.1";

  src = fetchurl {
    url = "http://webhome.phy.duke.edu/~rgb/General/dieharder/dieharder-${version}.tgz";
    hash = "sha256-bP8P+DlMVTVJrHQzNZzPyVX7JnlCYDFGIN+l5M1Lcn8=";
  };

  patches = [
    # Include missing stdint.h header
    ./stdint.patch
  ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: include/dieharder/parse.h:21: multiple definition of `splitbuf';
  #     include/dieharder/parse.h:21: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  buildInputs = [ gsl ];

  passthru = {
    tests.version = testers.testVersion { package = dieharder; };
  };

  meta = with lib; {
    description = "A Random Number Generator test suite";
    mainProgram = "dieharder";
    homepage = "https://webhome.phy.duke.edu/~rgb/General/dieharder.php";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zhaofengli ];
    platforms = platforms.unix;
  };
}
