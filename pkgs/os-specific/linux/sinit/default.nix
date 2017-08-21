{stdenv, fetchgit, rcinit ? null, rcshutdown ? null, rcreboot ? null}:
let
  s = # Generated upstream information
  rec {
    baseName="sinit";
    version="1.0";
    name="${baseName}-${version}";
    url="http://git.suckless.org/sinit/";
    sha256="0cf8yylgrrj1wxm5v6jdlbnxpx97m38yxrc9nmv1l8hldjqsj9pc";
    rev = "refs/tags/v${version}";
  };
  buildInputs = [
    (stdenv.lib.getOutput "static" stdenv.cc.libc)
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
    + (stdenv.lib.optionalString (rcinit != null) ''sed -re 's@(rcinitcmd[^"]*")[^"]*"@\1${rcinit}"@' -i config.def.h; '')
    + (stdenv.lib.optionalString (rcshutdown != null) ''sed -re 's@(rc(reboot|poweroff)cmd[^"]*")[^"]*"@\1${rcshutdown}"@' -i config.def.h; '')
    + (stdenv.lib.optionalString (rcreboot != null) ''sed -re 's@(rc(reboot)cmd[^"]*")[^"]*"@\1${rcreboot}"@' -i config.def.h; '')
    ;
  meta = {
    inherit (s) version;
    description = ''A very minimal Linux init implementation from suckless.org'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://tools.suckless.org/sinit;
    downloadPage = "http://git.suckless.org/sinit";
  };
}
