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
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "PackageKit-Qt";
    tag = "v${version}";
    hash = "sha256-D1LsEaxc6lA0ULmYQ9n2KEs6NpoHeTgOJsKzdEnImUM=";
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
