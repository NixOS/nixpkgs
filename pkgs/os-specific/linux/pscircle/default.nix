{ stdenv, fetchFromGitLab, meson, pkgconfig, ninja, cairo }:

stdenv.mkDerivation rec {
  name = "pscircle-${version}";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "mildlyparallel";
    repo = "pscircle";
    rev = "v${version}";
    sha256 = "1sxdnhkcr26l29nk0zi1zkvkd7128xglfql47rdb1bx940vflgb6";
  };

  buildInputs = [
      meson
      pkgconfig
      cairo
      ninja
  ];

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/mildlyparallel/pscircle;
    description = "Visualize Linux processes in a form of a radial tree";
    license = licenses.gpl2;
    maintainers = [ maintainers.ldesgoui ];
    platforms = platforms.linux;
  };
}
