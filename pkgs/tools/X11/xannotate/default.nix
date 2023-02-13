{lib, stdenv, fetchFromBitbucket, fetchpatch, libX11}:
stdenv.mkDerivation rec {
  pname = "xannotate";
  version = "20150301";

  src = fetchFromBitbucket {
    owner = "blais";
    repo = pname;
    rev = "e5591c2ec67ca39988f1fb2966e94f0f623f9aa7";
    sha256 = "02jy19if0rnbxvs6b0l5mi9ifvdj2qmv0pv278v9kfs0kvir68ik";
  };

  patches = [
    # Pull patch pending upstream inclusion for -gno-common tollchains:
    #   https://github.com/blais/xannotate/pull/1
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/blais/xannotate/commit/ee637e2dee103d0e654865c2202ea1b3af2a20d6.patch";
      sha256 = "1lw22d5qs1bwp53l332yl3yypfvwrbi750wp7yv90nfn3ia0xhni";
    })
  ];

  buildInputs = [ libX11 ];

  meta = {
    description = "A tool to scribble over X windows";
    license = lib.licenses.gpl2Plus ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/blais/xannotate";
  };
}
