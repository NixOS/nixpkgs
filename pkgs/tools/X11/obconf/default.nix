{ lib
, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, wrapGAppsHook
, gtk3
, imlib2
, libSM
, libstartup_notification
, libxml2
, openbox
}:

stdenv.mkDerivation rec {
  pname = "obconf";
  version = "unstable-2015-02-13";

  src = fetchgit {
    url = "git://git.openbox.org/dana/obconf";
    rev = "63ec47c5e295ad4f09d1df6d92afb7e10c3fec39";
    sha256 = "sha256-qwm66VA/ueRMFtSUcrmuObNkz+KYgWRnmR7TnQwpxiE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    imlib2
    libSM
    libstartup_notification
    libxml2
    openbox
  ];

  postPatch = ''
    substituteInPlace configure.ac --replace 2.0.4 ${version}
  '';

  meta = {
    description = "GUI configuration tool for openbox";
    homepage = "http://openbox.org/wiki/ObConf";
    changelog = "http://openbox.org/wiki/ObConf:Changelog";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sfrijters ];
    platforms = lib.platforms.linux;
    mainProgram = "obconf";
  };
}
