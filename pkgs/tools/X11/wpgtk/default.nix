{
  lib,
  python3Packages,
  fetchFromGitHub,
  libxslt,
  gobject-introspection,
  gtk3,
  wrapGAppsHook3,
  gnome,
}:

python3Packages.buildPythonApplication rec {
  pname = "wpgtk";
  version = "6.5.9";

  src = fetchFromGitHub {
    owner = "deviantfero";
    repo = "wpgtk";
    rev = version;
    sha256 = "sha256-NlJG9d078TW1jcnVrpBORIIwDUGIAGWZoDbXp9/qRr4=";
  };

  nativeBuildInputs = [
    gobject-introspection
  ];

  buildInputs = [
    wrapGAppsHook3
    gtk3
    gnome.adwaita-icon-theme
    libxslt
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pillow
    pywal
  ];

  # The $HOME variable must be set to build the package. A "permission denied" error will occur otherwise
  preBuild = ''
    export HOME=$(pwd)
  '';

  # No test exist
  doCheck = false;

  meta = with lib; {
    description = "Template based wallpaper/colorscheme generator and manager";
    longDescription = ''
      In short, wpgtk is a colorscheme/wallpaper manager with a template system attached which lets you create templates from any textfile and will replace keywords on it on the fly, allowing for great styling and theming possibilities.

      wpgtk uses pywal as its colorscheme generator, but builds upon it with a UI and other features, such as the abilty to mix and edit the colorschemes generated and save them with their respective wallpapers, having light and dark themes, hackable and fast GTK theme made specifically for wpgtk and custom keywords and values to replace in templates.

      INFO: To work properly, this tool needs "programs.dconf.enable = true" on nixos or dconf installed. A reboot may be required after installing dconf.
    '';
    homepage = "https://github.com/deviantfero/wpgtk";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      melkor333
      cafkafk
    ];
    mainProgram = "wpg";
  };
}
