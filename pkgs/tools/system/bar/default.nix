{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "bar";
  version = "1.11.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/clpbar/clpbar/bar-${version}/bar_${version}.tar.gz";
    sha256 = "00v5cb6vzizyyhflgr62d3k8dqc0rg6wdgfyyk11c0s0r32mw3zs";
  };

  meta = {
    description = "Console progress bar";
    homepage = "https://clpbar.sourceforge.net/";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.rdnetto ];
    platforms = lib.platforms.all;
    mainProgram = "bar";
  };
}
