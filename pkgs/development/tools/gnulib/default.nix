{ lib, stdenv, fetchgit, python3 }:

stdenv.mkDerivation {
  pname = "gnulib";
  version = "20210702";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/r/gnulib.git";
    rev = "901694b904cd861adc2529b2e05a3fb33f9b534f";
    sha256 = "1f5znlv2wjziglw9vlygdgm4jfbsz34h2dz6w4h90bl4hm0ycb1w";
  };

  postPatch = ''
    patchShebangs gnulib-tool.py
  '';

  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/
    ln -s $out/lib $out/include
    ln -s $out/gnulib-tool $out/bin/
  '';

  # do not change headers to not update all vendored build files
  dontFixup = true;

  meta = with lib; {
    description = "Central location for code to be shared among GNU packages";
    homepage = "https://www.gnu.org/software/gnulib/";
    license = licenses.gpl3Plus;
    mainProgram = "gnulib-tool";
    platforms = platforms.unix;
  };
}
