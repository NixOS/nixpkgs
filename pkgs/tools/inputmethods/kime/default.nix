{ lib, stdenv, rustPlatform, rustc, cargo, fetchFromGitHub, pkg-config, cmake, extra-cmake-modules, llvmPackages
, withWayland ? true
, withIndicator ? true, dbus, libdbusmenu
, withXim ? true, xorg, cairo
, withGtk2 ? true, gtk2
, withGtk3 ? true, gtk3
, withQt5 ? true, qt5
}:

let
  cmake_args = lib.optionals withGtk2 ["-DENABLE_GTK2=ON"]
  ++ lib.optionals withGtk3 ["-DENABLE_GTK3=ON"]
  ++ lib.optionals withQt5 ["-DENABLE_QT5=ON"];

  optFlag = w: (if w then "1" else "0");
in
stdenv.mkDerivation rec {
  pname = "kime";
  version = "2.5.6";

  src = fetchFromGitHub {
    owner = "Riey";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r5luI6B4IjNTbh2tzpqabokgwkmbyXrA61+F2HDEWuo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sha256 = "sha256-GvBnNPY51RPt+I73oet5tB/EE2UsEPKbelJZkSY3xNw=";
  };

  # Replace autostart path
  postPatch = ''
    substituteInPlace res/kime.desktop --replace "/usr/bin/kime" "$out/bin/kime"
  '';

  dontUseCmakeConfigure = true;
  dontWrapQtApps = true;
  buildPhase = ''
    runHook preBuild
    export KIME_BUILD_CHECK=1
    export KIME_BUILD_INDICATOR=${optFlag withIndicator}
    export KIME_BUILD_XIM=${optFlag withXim}
    export KIME_BUILD_WAYLAND=${optFlag withWayland}
    export KIME_BUILD_KIME=1
    export KIME_CARGO_ARGS="-j$NIX_BUILD_CORES --frozen"
    export KIME_MAKE_ARGS="-j$NIX_BUILD_CORES"
    export KIME_CMAKE_ARGS="${lib.concatStringsSep " " cmake_args}"
    bash scripts/build.sh -r
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    cargo test --release --frozen
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    export KIME_BIN_DIR=bin
    export KIME_INSTALL_HEADER=1
    export KIME_INSTALL_DOC=1
    export KIME_INCLUDE_DIR=include
    export KIME_DOC_DIR=share/doc/kime
    export KIME_ICON_DIR=share/icons
    export KIME_LIB_DIR=lib
    export KIME_QT5_DIR=lib/qt-${qt5.qtbase.version}
    bash scripts/install.sh "$out"
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    # Don't pipe output to head directly it will cause broken pipe error https://github.com/rust-lang/rust/issues/46016
    kimeVersion=$(echo "$($out/bin/kime --version)" | head -n1)
    echo "'kime --version | head -n1' returns: $kimeVersion"
    [[ "$kimeVersion" == "kime ${version}" ]]
    runHook postInstallCheck
  '';

  buildInputs = lib.optionals withIndicator [ dbus libdbusmenu ]
  ++ lib.optionals withXim [ xorg.libxcb cairo ]
  ++ lib.optionals withGtk2 [ gtk2 ]
  ++ lib.optionals withGtk3 [ gtk3 ]
  ++ lib.optionals withQt5 [ qt5.qtbase ];

  nativeBuildInputs = [
    pkg-config
    llvmPackages.clang
    llvmPackages.libclang
    llvmPackages.bintools
    cmake
    extra-cmake-modules
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  RUST_BACKTRACE = 1;
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  meta = with lib; {
    homepage = "https://github.com/Riey/kime";
    description = "Korean IME";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.riey ];
    platforms = platforms.linux;
  };
}
