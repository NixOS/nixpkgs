{ stdenv, fetchFromGitLab, meson, ninja, pkgconfig
, python36Packages, gnome3, gst_all_1, gtk3, libnotify
, kid3, easytag, gobjectIntrospection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "lollypop-portal-${version}";
  version = "0.9.7";

  src = fetchFromGitLab {
     domain = "gitlab.gnome.org";
     owner = "gnumdk";
     repo = name;
     rev = version;
     sha256 = "0rn5xmh6391i9l69y613pjad3pzdilskr2xjfcir4vpk8wprvph3";
  };

  nativeBuildInputs = [
    gobjectIntrospection
    meson
    ninja
    pkgconfig
    python36Packages.wrapPython
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.totem-pl-parser
    gnome3.libsecret
    gnome3.gnome-settings-daemon

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base

    gtk3
    libnotify
  ];

  pythonPath = with python36Packages; [
    pygobject3
    pydbus
    pycairo
  ];

  preFixup = ''
    buildPythonPath "$out/libexec/lollypop-portal $pythonPath"

    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
      --prefix PATH : "${stdenv.lib.makeBinPath [ easytag kid3 ]}"
    )
  '';

  meta = with stdenv.lib; {
    description = "DBus Service for Lollypop";
    homepage = https://gitlab.gnome.org/gnumdk/lollypop-portal;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
