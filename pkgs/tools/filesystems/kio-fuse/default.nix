{ lib
, mkDerivation
, fetchgit
, cmake
, extra-cmake-modules
, kio
, fuse3
}:

mkDerivation rec {
  pname = "kio-fuse";
  version = "5.1.0";

  src = fetchgit {
    url = "https://invent.kde.org/system/kio-fuse.git";
    hash = "sha256-xVeDNkSeHCk86L07lPVokSgHNkye2tnLoCkdw4g2Jv0=";
    rev = "v${version}";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [ kio fuse3 ];

  meta = with lib; {
    description = "FUSE Interface for KIO";
    homepage = "https://invent.kde.org/system/kio-fuse";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ _1000teslas ];
  };
}
