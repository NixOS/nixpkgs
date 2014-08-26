{ stdenv, fetchurl, automake, vanilla ? false }:

let
  inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  name = "pkg-config-0.28";

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "http://pkgconfig.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0igqq5m204w71m11y0nipbdf5apx87hwfll6axs12hn4dqfb6vkb";
  };
    # Process Requires.private properly, see
    # http://bugs.freedesktop.org/show_bug.cgi?id=4738.
  patches = optional (!vanilla) ./requires-private.patch;

  preConfigure = stdenv.lib.optionalString (stdenv.system == "mips64el-linux")
    ''cp -v ${automake}/share/automake*/config.{sub,guess} .'';

  configureFlags = [ "--with-internal-glib" ];

  postInstall = ''rm "$out"/bin/*-pkg-config''; # clean the duplicate file

  meta = {
    description = "A tool that allows packages to find out information about other packages";
    homepage = http://pkg-config.freedesktop.org/wiki/;
    platforms = stdenv.lib.platforms.all;
  };

}

