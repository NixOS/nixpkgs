{ stdenv, fetchFromGitLab, cmake, extra-cmake-modules, qtbase, wrapQtAppsHook, kio, ki18n, polkit-qt }:

stdenv.mkDerivation rec {
  pname = "kio-admin";
  version = "1.0.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "system";
    repo = "kio-admin";
    rev = "v${version}";
    hash = "sha256-llnUsOttqFJVArJdZS9s6qHS9eGbdtdoaPMXKHtsUn4=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [ qtbase kio ki18n polkit-qt ];
}
