{stdenv, fetchurl, ghc}:

stdenv.mkDerivation {
  name = "bnfc-2.4-beta1";

  src = fetchurl {
    url = "https://svn.spraakdata.gu.se/clt/release/bnfc_2.4_beta_1.tgz";
    sha256 = "1njnck3m6qpp0qw11v1chf6m217j8f85bsgjl7zcpb4py18mjjrx";
  };

  buildInputs = [ghc];

  preConfigure = "cd source";

  meta = {
    description = "Compiler construction tool generating a compiler front-end from a Labelled BNF grammar";
    platforms = stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
