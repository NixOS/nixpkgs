{ stdenv, wayland, wayland-protocols, xorgserver, xkbcomp, xkeyboard_config, epoxy, libxslt, libunwind, makeWrapper, egl-wayland }:

with stdenv.lib;

xorgserver.overrideAttrs (oldAttrs: {

  name = "xwayland-${xorgserver.version}";
  buildInputs = oldAttrs.buildInputs ++ [ egl-wayland ];
  propagatedBuildInputs = oldAttrs.propagatedBuildInputs
    ++ [wayland wayland-protocols epoxy libxslt makeWrapper libunwind];
  configureFlags = [
    "--disable-docs"
    "--disable-devel-docs"
    "--enable-xwayland"
    "--enable-xwayland-eglstream"
    "--disable-xorg"
    "--disable-xvfb"
    "--disable-xnest"
    "--disable-xquartz"
    "--disable-xwin"
    "--enable-glamor"
    "--with-default-font-path="
    "--with-xkb-bin-directory=${xkbcomp}/bin"
    "--with-xkb-path=${xkeyboard_config}/etc/X11/xkb"
    "--with-xkb-output=$(out)/share/X11/xkb/compiled"
  ];

  postInstall = ''
    rm -fr $out/share/X11/xkb/compiled
  '';

  meta = {
    description = "An X server for interfacing X11 apps with the Wayland protocol";
    homepage = https://wayland.freedesktop.org/xserver.html;
    license = licenses.mit;
    platforms = platforms.linux;
  };
})
