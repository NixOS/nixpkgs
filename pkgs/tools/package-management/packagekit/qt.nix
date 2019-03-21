{ stdenv, fetchFromGitHub, cmake, pkgconfig
, qttools, packagekit }:

stdenv.mkDerivation rec {
  name = "packagekit-qt-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner  = "hughsie";
    repo   = "PackageKit-Qt";
    rev    = "v${version}";
    sha256 = "1ls6mn9abpwzw5wjgmslc5h9happj3516y1q67imppczk8g9h2yk";
  };

  buildInputs = [ packagekit ];

  nativeBuildInputs = [ cmake pkgconfig qttools ];

  enableParallelBuilding = true;

  meta = packagekit.meta // {
    description = "System to facilitate installing and updating packages - Qt";
  };
}
