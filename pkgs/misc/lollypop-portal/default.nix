{ stdenv, fetchFromGitLab, meson, ninja, pkgconfig
, python3, gnome3, gst_all_1, gtk3, libnotify
, kid3, easytag, gobjectIntrospection, wrapGAppsHook }:

python3.pkgs.buildPythonApplication rec {
  name = "lollypop-portal-${version}";
  version = "0.9.7";

  format = "other";
  doCheck = false;

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
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.gnome-settings-daemon
    gnome3.libsecret
    gnome3.totem-pl-parser
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk3
    libnotify
    python3
  ];

  pythonPath = with python3.pkgs; [
    pycairo
    pydbus
    pygobject3
  ];

  preFixup = ''
    buildPythonPath "$out/libexec/lollypop-portal $pythonPath"
    patchPythonScript "$out/libexec/lollypop-portal"

    gappsWrapperArgs+=(
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
