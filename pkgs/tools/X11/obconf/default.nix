{ lib, stdenv, fetchgit, autoreconfHook, pkg-config, gtk3, openbox,
  imlib2, libxml2, libstartup_notification, makeWrapper, libSM }:

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
    makeWrapper
    pkg-config
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

  postInstall = ''
    wrapProgram $out/bin/obconf --prefix XDG_DATA_DIRS : ${openbox}/share/
  '';

  meta = {
    description = "GUI configuration tool for openbox";
    homepage = "http://openbox.org/wiki/ObConf";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sfrijters ];
    platforms = lib.platforms.linux;
  };
}
