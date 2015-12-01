{ stdenv, fetchgit, autoreconfHook, pkgconfig, libcap, ostree, glib, libsoup
, libseccomp, libgsystem }:

stdenv.mkDerivation rec {
  name = "xdg-app-2015-08-15";

  src = fetchgit {
    url = "https://github.com/alexlarsson/xdg-app";
    rev = "4f73eaf10b7059fa81ed489bb9f0798d03f4f7ce";
    sha256 = "1j82ykiah4rdrpjc7k90xal4vwpgjp2bmna2bv7vqijc88y0d1kx";
  };

  patchPhase = ''
    substituteInPlace Makefile.am --replace "-DHELPER=\\\"\$(bindir)/xdg-app-helper" "-DHELPER=\\\"/var/setuid-wrappers/xdg-app-helper"
    sed -e 's,$(libglnx_srcpath),'libglnx,g < libglnx/Makefile-libglnx.am >libglnx/Makefile-libglnx.am.inc
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libcap ostree glib libsoup libseccomp libgsystem ];

  configureFlags = [ "--disable-documentation" ];

  meta = {
    description = "xdg-app";
    homepage = "https://wiki.gnome.org/Projects/SandboxedApps";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
  };
}
