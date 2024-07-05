{ stdenv, lib, fetchFromGitHub, cmake, pkg-config
, qttools, packagekit }:

let
  isQt6 = lib.versions.major qttools.version == "6";
in stdenv.mkDerivation rec {
  pname = "packagekit-qt";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner  = "hughsie";
    repo   = "PackageKit-Qt";
    rev    = "v${version}";
    sha256 = "sha256-pwDMLd+Gpl0P2ImPjGeZpKAOJ4dH5+P1se0l1qm5Ui0=";
  };

  buildInputs = [ packagekit ];

  nativeBuildInputs = [ cmake pkg-config qttools ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_WITH_QT6" isQt6) ];

  dontWrapQtApps = true;

  meta = packagekit.meta // {
    description = "System to facilitate installing and updating packages - Qt";
  };
}
