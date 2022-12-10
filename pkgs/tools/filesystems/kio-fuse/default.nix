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
  version = "5.0.1";

  src = fetchgit {
    url = "https://invent.kde.org/system/kio-fuse.git";
    sha256 = "sha256-LSFbFCaEPkQTk1Rg9xpueBOQpkbr/tgYxLD31F6i/qE=";
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
