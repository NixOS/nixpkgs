{ lib, stdenv, rustPlatform, rustc, cargo, fetchFromGitHub, pkg-config, cmake, extra-cmake-modules
, withWayland ? true
, withIndicator ? true, dbus, libdbusmenu
, withXim ? true, xorg, cairo
, withGtk3 ? true, gtk3
, withGtk4 ? true, gtk4
, withQt5 ? true, qt5
, withQt6 ? false, qt6
}:

let
  cmake_args = lib.optionals withGtk3 ["-DENABLE_GTK3=ON"]
  ++ lib.optionals withGtk4 ["-DENABLE_GTK4=ON"]
  ++ lib.optionals withQt5 ["-DENABLE_QT5=ON"]
  ++ lib.optionals withQt6 ["-DENABLE_QT6=ON"];

  optFlag = w: (if w then "1" else "0");
in
stdenv.mkDerivation rec {
  pname = "kime";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "Riey";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qLQ6DmV7KHhdXWR5KtO52cmXBm818zKJVj4nxsR14dc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sha256 = "sha256-/o9b7YvrpV+IujkllFWAz6Mg4CbS9BInF8antfZ0Vsw=";
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
    export KIME_QT6_DIR=lib/qt-${qt6.qtbase.version}
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
  ++ lib.optionals withGtk3 [ gtk3 ]
  ++ lib.optionals withGtk4 [ gtk4 ]
  ++ lib.optionals withQt5 [ qt5.qtbase ]
  ++ lib.optionals withQt6 [ qt6.qtbase ];

  nativeBuildInputs = [
    pkg-config
    cmake
    extra-cmake-modules
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  RUST_BACKTRACE = 1;

  meta = with lib; {
    homepage = "https://github.com/Riey/kime";
    description = "Korean IME";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.riey ];
    platforms = platforms.linux;
  };
}
