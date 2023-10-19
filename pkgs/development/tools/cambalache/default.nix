{ stdenv
, lib
, fetchFromGitLab
, python3
, meson
, ninja
, pkg-config
, gobject-introspection
, desktop-file-utils
, shared-mime-info
, wrapGAppsHook
, glib
, gtk3
, gtk4
, gtksourceview4
, libadwaita
, libhandy
, webkitgtk_4_1
, webkitgtk_6_0
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cambalache";
  version = "0.12.1";

  format = "other";

  # Did not fetch submodule since it is only for tests we don't run.
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jpu";
    repo = pname;
    rev = version;
    sha256 = "sha256-kGCpccWIhaeWrzLlrDI7Vzd0KuAIKxvLrDuSqWtpSLU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection # for setup hook
    desktop-file-utils # for update-desktop-database
    shared-mime-info # for update-mime-database
    wrapGAppsHook
  ];

  pythonPath = with python3.pkgs; [
    pygobject3
    lxml
  ];

  buildInputs = [
    glib
    gtk3
    gtk4
    gtksourceview4
    webkitgtk_4_1
    webkitgtk_6_0
    # For extra widgets support.
    libadwaita
    libhandy
  ];

  # Prevent double wrapping.
  dontWrapGApps = true;

  postPatch = ''
    patchShebangs postinstall.py
    # those programs are used at runtime not build time
    # https://gitlab.gnome.org/jpu/cambalache/-/blob/0.12.1/meson.build#L79-80
    substituteInPlace ./meson.build \
      --replace "find_program('broadwayd', required: true)" "" \
      --replace "find_program('gtk4-broadwayd', required: true)" ""
  '';

  preFixup = ''
    # Let python wrapper use GNOME flags.
    makeWrapperArgs+=(
      # For broadway daemons
      --prefix PATH : "${lib.makeBinPath [ gtk3 gtk4 ]}"
      "''${gappsWrapperArgs[@]}"
    )
  '';

  postFixup = ''
    # Wrap a helper script in an unusual location.
    wrapPythonProgramsIn "$out/${python3.sitePackages}/cambalache/priv/merengue" "$out $pythonPath"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/jpu/cambalache";
    description = "RAD tool for GTK 4 and 3 with data model first philosophy";
    maintainers = teams.gnome.members;
    license = with licenses; [
      lgpl21Only # Cambalache
      gpl2Only # tools
    ];
    platforms = platforms.unix;
  };
}
