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
, boost
, libxmlxx3
, mesa
, pciutils
}:

stdenv.mkDerivation rec {
  pname = "adriconf";
  version = "2.4.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = pname;
    rev = "v${version}";
    sha256 = "hZy+FpKKBKuho/fALu2O+44zzK6s/M8CTbhrO00ANgo=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libdrm libGL atkmm pcre gtkmm3 boost libxmlxx3 mesa pciutils ];

  cmakeFlags = [ "-DENABLE_UNIT_TESTS=off" ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/mesa/adriconf/";
    description = "A GUI tool used to configure open source graphics drivers";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ musfay ];
    platforms = platforms.linux;
  };
}
