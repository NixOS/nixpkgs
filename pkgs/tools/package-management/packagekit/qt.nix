{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qttools,
  packagekit,
}:

stdenv.mkDerivation rec {
  pname = "packagekit-qt";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "PackageKit-Qt";
    tag = "v${version}";
    hash = "sha256-ZHkOFPaOMLCectYKzQs9oQ70kv8APOdkjDRimHgld+c=";
  };

  buildInputs = [ packagekit ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
  ];

  dontWrapQtApps = true;

  meta = packagekit.meta // {
    description = "System to facilitate installing and updating packages - Qt";
  };
}
