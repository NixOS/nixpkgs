{lib, stdenv, fetchgit, rcinit ? null, rcshutdown ? null, rcreboot ? null}:
let
  s = # Generated upstream information
  rec {
    baseName="sinit";
    version="1.1";
    name="${baseName}-${version}";
    url="https://git.suckless.org/sinit/";
    sha256="sha256-VtXkgixgElKKOT26uKN9feXDVjjtSgTWvcgk5o5MLmw=";
    rev = "refs/tags/v${version}";
  };
  buildInputs = [
    (lib.getOutput "static" stdenv.cc.libc)
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchgit {
    inherit (s) url sha256 rev;
  };
  makeFlags = ["PREFIX=$(out)"];
  preConfigure = ""
    + (lib.optionalString (rcinit != null) ''sed -re 's@(rcinitcmd[^"]*")[^"]*"@\1${rcinit}"@' -i config.def.h; '')
    + (lib.optionalString (rcshutdown != null) ''sed -re 's@(rc(reboot|poweroff)cmd[^"]*")[^"]*"@\1${rcshutdown}"@' -i config.def.h; '')
    + (lib.optionalString (rcreboot != null) ''sed -re 's@(rc(reboot)cmd[^"]*")[^"]*"@\1${rcreboot}"@' -i config.def.h; '')
    ;
  meta = {
    inherit (s) version;
    description = "A very minimal Linux init implementation from suckless.org";
    license = lib.licenses.mit ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "https://tools.suckless.org/sinit";
    downloadPage = "https://git.suckless.org/sinit";
  };
}
