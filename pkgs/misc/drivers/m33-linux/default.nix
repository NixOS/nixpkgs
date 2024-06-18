{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation {
  pname = "M33-Linux";
  version = "unstable-2016-06-23";

  src = fetchFromGitHub {
    owner = "donovan6000";
    repo = "M3D-Linux";
    rev = "5c1b90c13d260771dac970b49fdc9f840fee5f4a";
    sha256 = "1bvbclkyfcv23vxb4s1zssvygklks1nhp4iwi4v90c1fvyz0356f";
  };

  patches = [
    # Pull the `gcc-13` build fix pending upstream inclusion:
    #   https://github.com/donovan6000/M33-Linux/pull/6
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/donovan6000/M33-Linux/commit/272e4488ef05cfd95fcc952becfc0ac982306d0c.patch";
      hash = "sha256-ubdCwXFVljvOCzYrWVJgU6PY1j6Ei6aaclhXaGwZT2w=";
    })
  ];

  installPhase = ''
    install -Dm755 m33-linux $out/bin/m33-linux
    install -Dm755 90-micro-3d-local.rules $out/lib/udev/rules.d/90-micro-3d-local.rules
  '';

  meta = with lib; {
    homepage = "https://github.com/donovan6000/M3D-Linux";
    description = "Linux program that can communicate with the Micro 3D printer";
    mainProgram = "m33-linux";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
