{lib, stdenv, fetchFromBitbucket, libX11}:
stdenv.mkDerivation rec {
  pname = "xannotate";
  version = "20150301";

  src = fetchFromBitbucket {
    owner = "blais";
    repo = pname;
    rev = "e5591c2ec67ca39988f1fb2966e94f0f623f9aa7";
    sha256 = "02jy19if0rnbxvs6b0l5mi9ifvdj2qmv0pv278v9kfs0kvir68ik";
  };

  buildInputs = [ libX11 ];

  meta = {
    description = "A tool to scribble over X windows";
    license = lib.licenses.gpl2Plus ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "https://bitbucket.org/blais/xannotate";
  };
}
