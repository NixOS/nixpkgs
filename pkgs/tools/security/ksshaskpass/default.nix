{stdenv, fetchurl, kdelibs}:

stdenv.mkDerivation {
  name = "ksshaskpass-0.5.3";

  src = fetchurl {
    url = http://kde-apps.org/CONTENT/content-files/50971-ksshaskpass-0.5.3.tar.gz;
    sha256 = "0911i8jr0nzqah8xidb8wba55a2skaidj3klv3cw6bm5fjx7x953";
  };

  buildInputs = [ kdelibs ];

  patchPhase = ''
    sed -i 's@/usr/bin/@@' src/ksshaskpass.desktop
  '';

  meta = {
    homepage = http://kde-apps.org/content/show.php?content=50971;
    description = "A KDE 4 version of ssh-askpass with KWallet support";
    license = stdenv.lib.licenses.gpl2Plus;
    inherit (kdelibs.meta) platforms;
  };
}
