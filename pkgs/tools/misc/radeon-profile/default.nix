{ stdenv, fetchFromGitHub, qtbase, qtcharts, qmake, libXrandr, libdrm }:

stdenv.mkDerivation rec {

  pname = "radeon-profile";
  version = "20170714";

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtcharts libXrandr libdrm ];

  src = (fetchFromGitHub {
    owner  = "marazmista";
    repo   = "radeon-profile";
    rev    = version;
    sha256 = "08fv824iq00zbl9xk9zsfs8gkk8rsy6jlxbmszrjfx7ji28hansd";
  }) + "/radeon-profile";

  postInstall = ''
    mkdir -p $out/bin
    cp ./radeon-profile $out/bin/radeon-profile
  '';

  meta = with stdenv.lib; {
    description = "Application to read current clocks of AMD Radeon cards";
    homepage    = https://github.com/marazmista/radeon-profile;
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
  };

}
