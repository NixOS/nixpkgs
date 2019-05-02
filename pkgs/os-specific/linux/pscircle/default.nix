{ stdenv, fetchFromGitLab, meson, pkgconfig, ninja, cairo }:

stdenv.mkDerivation rec {
  name = "pscircle-${version}";
  version = "1.3.0";

  src = fetchFromGitLab {
    owner = "mildlyparallel";
    repo = "pscircle";
    rev = "v${version}";
    sha256 = "0qsif00dkqa8ky3vl2ycx5anx2yk62nrv47f5lrlqzclz91f00fx";
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
