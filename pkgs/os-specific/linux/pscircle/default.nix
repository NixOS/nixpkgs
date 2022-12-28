{ lib, stdenv, fetchFromGitLab, meson, pkg-config, ninja, cairo }:

stdenv.mkDerivation rec {
  pname = "pscircle";
  version = "1.3.1";

  src = fetchFromGitLab {
    owner = "mildlyparallel";
    repo = "pscircle";
    rev = "v${version}";
    sha256 = "1sm99423hh90kr4wdjqi9sdrrpk65j2vz2hzj65zcxfxyr6khjci";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    cairo
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/mildlyparallel/pscircle";
    description = "Visualize Linux processes in a form of a radial tree";
    license = licenses.gpl2;
    maintainers = [ maintainers.ldesgoui ];
    platforms = platforms.linux;
  };
}
