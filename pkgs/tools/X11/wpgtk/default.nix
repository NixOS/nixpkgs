{ stdenv, python3Packages, fetchFromGitHub, feh, libxslt,
  gobject-introspection, gtk3, wrapGAppsHook, gnome3 }:

python3Packages.buildPythonApplication rec {
  pname = "wpgtk";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "deviantfero";
    repo = "wpgtk";
    rev = version;
    sha256 = "00nrc6ad2y0ivics6gpg63s86m8014a79yjn1q6d905qx32kk9dr";
  };

  buildInputs = [
    wrapGAppsHook
    gtk3
    gobject-introspection
    gnome3.adwaita-icon-theme
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

  meta = with stdenv.lib; {
    description = "Template based wallpaper/colorscheme generator and manager";
    longDescription = ''
     In short, wpgtk is a colorscheme/wallpaper manager with a template system attached which lets you create templates from any textfile and will replace keywords on it on the fly, allowing for great styling and theming possibilities.

     wpgtk uses pywal as its colorscheme generator, but builds upon it with a UI and other features, such as the abilty to mix and edit the colorschemes generated and save them with their respective wallpapers, having light and dark themes, hackable and fast GTK+ theme made specifically for wpgtk and custom keywords and values to replace in templates.

     INFO: To work properly, this tool needs "programs.dconf.enable = true" on nixos or dconf installed. A reboot may be required after installing dconf.
     '';
    homepage = https://github.com/deviantfero/wpgtk;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.melkor333 ];
  };
}
