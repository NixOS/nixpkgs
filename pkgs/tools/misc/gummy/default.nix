{ lib
, stdenv
, fetchFromGitHub
, testers
, gummy
, cmake
, libX11
, libXext
, sdbus-cpp
, udev
, coreutils
}:

stdenv.mkDerivation rec {
  pname = "gummy";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "fushko";
    repo = "gummy";
    rev = version;
    sha256 = "sha256-nX5wEJ4HmgFHIgJP2MstBzQjU/9lrXOXoIl1vlolqak=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libX11
    libXext
    sdbus-cpp
    udev
  ];

  cmakeFlags = [
    "-DUDEV_DIR=${placeholder "out"}/lib/udev"
  ];

  # Fixes the "gummy start" command, without this it cannot find the binary.
  # Setting this through cmake does not seem to work.
  postPatch = ''
    substituteInPlace src/gummy/gummy.cpp \
      --replace "CMAKE_INSTALL_DAEMON_PATH" "\"${placeholder "out"}/libexec/gummyd\""
  '';

  preFixup = ''
    substituteInPlace $out/lib/udev/99-gummy.rules \
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
    maintainers = [ maintainers.ivar ];
  };
}
