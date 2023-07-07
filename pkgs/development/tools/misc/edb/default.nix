{ lib, mkDerivation, fetchFromGitHub, cmake, pkg-config, boost, capstone
, double-conversion, graphviz, qtxmlpatterns }:

mkDerivation rec {
  pname = "edb";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "eteran";
    repo = "edb-debugger";
    rev = "1.3.0";
    fetchSubmodules = true;
    sha256 = "fFUau8XnsRFjC83HEsqyhrwCCBOfDmV6oACf3txm7O8=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ boost.dev capstone double-conversion graphviz qtxmlpatterns ];

  postPatch = ''
    # Remove CMAKE_INSTALL_PREFIX from DEFAULT_PLUGIN_PATH otherwise the nix store path will appear twice.
    substituteInPlace ./src/CMakeLists.txt --replace \
        '-DDEFAULT_PLUGIN_PATH=\"''${CMAKE_INSTALL_PREFIX}/''${CMAKE_INSTALL_LIBDIR}/edb\"' \
        '-DDEFAULT_PLUGIN_PATH=\"''${CMAKE_INSTALL_LIBDIR}/edb\"'

    # The build script checks for the presence of .git to determine whether
    # submodules were fetched and will throw an error if it's not there.
    # Avoid using leaveDotGit in the fetchFromGitHub options as it is non-deterministic.
    mkdir -p src/qhexview/.git

    # Change default optional terminal program path to one that is more likely to work on NixOS.
    substituteInPlace ./src/Configuration.cpp --replace "/usr/bin/xterm" "xterm";

    sed '1i#include <memory>' -i include/{RegisterViewModelBase,State,IState}.h # gcc12
  '';

  meta = with lib; {
    description = "Cross platform AArch32/x86/x86-64 debugger";
    homepage = "https://github.com/eteran/edb-debugger";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lihop maxxk ];
    platforms = [ "x86_64-linux" ];
  };
}
