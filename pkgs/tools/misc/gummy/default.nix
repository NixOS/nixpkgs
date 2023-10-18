{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, testers
, gummy
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

stdenv.mkDerivation rec {
  pname = "gummy";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "fushko";
    repo = "gummy";
    rev = version;
    sha256 = "sha256-cRYmBeHvTpw+cwAZzw5qjMRFPINRa7xRXixZzPKwE84=";
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

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./cmake_no_fetch.patch;
      nlohmann_json_src = nlohmann_json.src;
      fmt_src = fmt.src;
      spdlog_src = spdlog.src;
      cli11_src = cli11.src;
    })
  ];

  # Fixes the "gummy start" command, without this it cannot find the binary.
  # Setting this through cmake does not seem to work.
  postPatch = ''
    substituteInPlace gummy/gummyd/gummyd/api.cpp \
      --replace "CMAKE_INSTALL_DAEMON_PATH" "\"${placeholder "out"}/libexec/gummyd\""
  '';

  preFixup = ''
    substituteInPlace $out/lib/udev/rules.d/99-gummy.rules \
      --replace "/bin/chmod" "${coreutils}/bin/chmod"

    ln -s $out/libexec/gummyd $out/bin/gummyd
  '';

  passthru.tests.version = testers.testVersion { package = gummy; };

  meta = with lib; {
    homepage = "https://github.com/Fushko/gummy";
    description = "Brightness and temperature manager for X11";
    longDescription = ''
      CLI screen manager for X11 that allows automatic and manual brightness/temperature adjustments,
      via backlight (currently only for embedded displays) and gamma. Multiple monitors are supported.
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ivar ];
  };
}
