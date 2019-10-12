{ stdenv, fetchFromGitHub, mkDerivation
, cmake, extra-cmake-modules
, qtbase, kcoreaddons, kdecoration }:

let
  version = "2017-03-15";
in mkDerivation rec {
  pname = "kde2-decoration";
  inherit version;

  src = fetchFromGitHub {
    owner = "repos-holder";
    repo = "kdecoration2-kde2";
    rev = "2a9cf18ac0646b3532d4db2dd28bd73c4c229783";
    sha256 = "0kilw6sd3blvm6gx9w4w5ivkjfxlv6wnyivw46pwwvhgxqymkbxk";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [ qtbase kcoreaddons kdecoration ];

  meta = with stdenv.lib; {
    description = "KDE 2 window decoration ported to Plasma 5";
    homepage = src.meta.homepage;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
