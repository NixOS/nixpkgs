{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "M33-Linux-2016-06-23";

  src = fetchFromGitHub {
    owner = "donovan6000";
    repo = "M3D-Linux";
    rev = "5c1b90c13d260771dac970b49fdc9f840fee5f4a";
    sha256 = "1bvbclkyfcv23vxb4s1zssvygklks1nhp4iwi4v90c1fvyz0356f";
  };

  installPhase = ''
    install -Dm755 m33-linux $out/bin/m33-linux
    install -Dm755 90-micro-3d-local.rules $out/lib/udev/rules.d/90-micro-3d-local.rules
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/donovan6000/M3D-Linux;
    description = "A Linux program that can communicate with the Micro 3D printer";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
