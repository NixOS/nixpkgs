{
  lib,
  stdenv,
  fetchurl,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "rkflashtool";
  version = "5.1";

  src = fetchurl {
    url = "mirror://sourceforge/rkflashtool/rkflashtool-${version}-src.tar.bz2";
    sha256 = "0dbp1crw7pjav9gffrnskhkf0gxlj4xgp65clqhvfmv32460xb9c";
  };

  versionh = fetchurl {
    url = "mirror://sourceforge/rkflashtool/version.h";
    sha256 = "1mkcy3yyfaddhzg524hjnhvmwdmdfzbavib8d9p5y38pcqy8xgdp";
  };

  buildInputs = [ libusb1 ];

  preBuild = ''
    cp $versionh version.h
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp rkunpack rkcrc rkflashtool rkparameters rkparametersblock rkunsign rkmisc $out/bin
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/rkflashtool/";
    description = "Tools for flashing Rockchip devices";
    platforms = platforms.linux;
    maintainers = [ maintainers.viric ];
    license = licenses.bsd2;
  };
}
