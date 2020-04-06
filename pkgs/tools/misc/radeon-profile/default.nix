{ lib, mkDerivation, fetchFromGitHub
, qtbase, qtcharts, qmake, libXrandr, libdrm
}:

mkDerivation rec {

  pname = "radeon-profile";
  version = "20190903";

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtcharts libXrandr libdrm ];

  src = (fetchFromGitHub {
    owner  = "marazmista";
    repo   = "radeon-profile";
    rev    = version;
    sha256 = "0ax5417q03xjwi3pn7yyjdb90ssaygdprfgb1pz9nkyk6773ckx5";
  }) + "/radeon-profile";

  preConfigure = ''
    substituteInPlace radeon-profile.pro \
      --replace "/usr/" "$out/"
  '';

  meta = with lib; {
    description = "Application to read current clocks of AMD Radeon cards";
    homepage    = https://github.com/marazmista/radeon-profile;
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
  };

}
