{ stdenv, fetchFromGitHub, cmake, pkg-config
, qttools, packagekit }:

stdenv.mkDerivation rec {
  pname = "packagekit-qt";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner  = "hughsie";
    repo   = "PackageKit-Qt";
    rev    = "v${version}";
    sha256 = "1d20r503msw1vix3nb6a8bmdqld7fj8k9jk33bkqsc610a2zsms6";
  };

  buildInputs = [ packagekit ];

  nativeBuildInputs = [ cmake pkg-config qttools ];

  dontWrapQtApps = true;

  meta = packagekit.meta // {
    description = "System to facilitate installing and updating packages - Qt";
  };
}
