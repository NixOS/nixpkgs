{ stdenv, fetchFromGitHub, cmake, pkg-config
, qttools, packagekit }:

stdenv.mkDerivation rec {
  pname = "packagekit-qt";
<<<<<<< HEAD
  version = "1.1.1";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "hughsie";
    repo   = "PackageKit-Qt";
    rev    = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-pwDMLd+Gpl0P2ImPjGeZpKAOJ4dH5+P1se0l1qm5Ui0=";
=======
    sha256 = "1d20r503msw1vix3nb6a8bmdqld7fj8k9jk33bkqsc610a2zsms6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ packagekit ];

  nativeBuildInputs = [ cmake pkg-config qttools ];

  dontWrapQtApps = true;

  meta = packagekit.meta // {
    description = "System to facilitate installing and updating packages - Qt";
  };
}
