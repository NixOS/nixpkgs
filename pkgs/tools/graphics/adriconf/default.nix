{ stdenv
, lib
, fetchFromGitLab
, cmake
, pkg-config
, libdrm
, libGL
, atkmm
, pcre
, gtkmm3
, pugixml
, mesa
, pciutils
}:

stdenv.mkDerivation rec {
  pname = "adriconf";
  version = "2.5.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RhHmrjb5TvJnZ6R0aefqdmwMBpu4iTrxSHru7JAwrgs=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libdrm libGL atkmm pcre gtkmm3 pugixml mesa pciutils ];

  cmakeFlags = [ "-DENABLE_UNIT_TESTS=off" ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/mesa/adriconf/";
    description = "A GUI tool used to configure open source graphics drivers";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.linux;
  };
}
