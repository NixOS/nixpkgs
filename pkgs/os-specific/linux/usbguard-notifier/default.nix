{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libqb,
  usbguard,
  librsvg,
  libnotify,
  catch2,
  asciidoc,
}:

stdenv.mkDerivation rec {
  pname = "usbguard-notifier";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Cropi";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-gWvCGSbOuey2ELAPD2WCG4q77IClL0S7rE2RaUJDc1I=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config asciidoc ];
  buildInputs = [ libqb usbguard librsvg libnotify ];

  configureFlags = [ "CPPFLAGS=-I${catch2}/include/catch2" ];

  prePatch = ''
    substituteInPlace configure.ac \
      --replace 'AC_MSG_FAILURE([Cannot detect the systemd system unit dir])' \
        'systemd_unit_dir="$out/lib/systemd/user"'
  '';

  meta = {
    description = "Notifications for detecting usbguard policy and device presence changes";
    homepage = "https://github.com/Cropi/usbguard-notifier";
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
