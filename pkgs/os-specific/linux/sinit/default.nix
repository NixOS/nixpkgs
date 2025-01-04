{
  lib,
  stdenv,
  fetchgit,
  rcinit ? null,
  rcshutdown ? null,
  rcreboot ? null,
}:

stdenv.mkDerivation rec {
  pname = "sinit";
  version = "1.1";

  src = fetchgit {
    url = "https://git.suckless.org/sinit/";
    sha256 = "sha256-VtXkgixgElKKOT26uKN9feXDVjjtSgTWvcgk5o5MLmw=";
    tag = "v${version}";
  };
  buildInputs = [
    (lib.getOutput "static" stdenv.cc.libc)
  ];
  makeFlags = [ "PREFIX=$(out)" ];
  preConfigure =
    ""
    + (lib.optionalString (
      rcinit != null
    ) ''sed -re 's@(rcinitcmd[^"]*")[^"]*"@\1${rcinit}"@' -i config.def.h; '')
    + (lib.optionalString (
      rcshutdown != null
    ) ''sed -re 's@(rc(reboot|poweroff)cmd[^"]*")[^"]*"@\1${rcshutdown}"@' -i config.def.h; '')
    + (lib.optionalString (
      rcreboot != null
    ) ''sed -re 's@(rc(reboot)cmd[^"]*")[^"]*"@\1${rcreboot}"@' -i config.def.h; '');

  meta = with lib; {
    description = "Very minimal Linux init implementation from suckless.org";
    mainProgram = "sinit";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "https://tools.suckless.org/sinit";
    downloadPage = "https://git.suckless.org/sinit";
  };
}
