{stdenv, fetchurl, automake}:

stdenv.mkDerivation (rec {
  name = "pkg-config-0.23";
  
  setupHook = ./setup-hook.sh;
  
  src = fetchurl {
    url = "http://pkgconfig.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0lrvk17724mc2nzpaa0vwybarrl50r7qdnr4h6jijm50srrf1808";
  };

  patches = [
    # Process Requires.private properly, see
    # http://bugs.freedesktop.org/show_bug.cgi?id=4738.
    ./requires-private.patch
  ];

  meta = {
    description = "A tool that allows packages to find out information about other packages";
    homepage = http://pkg-config.freedesktop.org/wiki/;
    platforms = stdenv.lib.platforms.all;
  };

} // (if stdenv.system == "mips64el-linux" then
  {
    preConfigure = ''
      cp -v ${automake}/share/automake*/config.{sub,guess} .
    '';
  } else {}))
