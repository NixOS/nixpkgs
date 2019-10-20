{ stdenv, fetchFromGitLab, meson, pkgconfig, ninja, cairo }:

stdenv.mkDerivation rec {
  pname = "pscircle";
  version = "1.3.1";

  src = fetchFromGitLab {
    owner = "mildlyparallel";
    repo = "pscircle";
    rev = "v${version}";
    sha256 = "1sm99423hh90kr4wdjqi9sdrrpk65j2vz2hzj65zcxfxyr6khjci";
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
