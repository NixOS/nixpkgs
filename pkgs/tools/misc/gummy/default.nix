{ lib
, stdenv
, fetchFromGitea
, testers
, cmake
, libX11
, libXext
, sdbus-cpp
, udev
, xcbutilimage
, coreutils
, cli11
, ddcutil
, fmt
, nlohmann_json
, spdlog
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gummy";
  version = "0.6.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "fusco";
    repo = "gummy";
    rev = finalAttrs.version;
    hash = "sha256-kATieFf+dEpcYgSEPoETacP7R+u2dOrg7rOhIkNQ1uE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    cli11
    ddcutil
    fmt
    libX11
    libXext
    nlohmann_json
    sdbus-cpp
    spdlog
    udev
    xcbutilimage
  ];

  cmakeFlags = [
    "-DUDEV_DIR=${placeholder "out"}/lib/udev"
    "-DUDEV_RULES_DIR=${placeholder "out"}/lib/udev/rules.d"
  ];

  # Fixes the "gummy start" command, without this it cannot find the binary.
  # Setting this through cmake does not seem to work.
  postPatch = ''
    substituteInPlace gummyd/gummyd/api.cpp \
      --replace "CMAKE_INSTALL_DAEMON_PATH" "\"${placeholder "out"}/libexec/gummyd\""
  '';

  preFixup = ''
    substituteInPlace $out/lib/udev/rules.d/99-gummy.rules \
      --replace "/bin/chmod" "${coreutils}/bin/chmod"

    ln -s $out/libexec/gummyd $out/bin/gummyd
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = with lib; {
    homepage = "https://codeberg.org/fusco/gummy";
    description = "Brightness and temperature manager for X11";
    longDescription = ''
      CLI screen manager for X11 that allows automatic and manual brightness/temperature adjustments,
      via backlight (currently only for embedded displays) and gamma. Multiple monitors are supported.
    '';
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
})
