{ stdenv, fetchurl, pkgconfig, intltool, python, pyrex, pygobject, pygtk
, notify, pythonDBus, bluez, glib, gtk, libstartup_notification
, makeWrapper, xdg_utils
}:
   
stdenv.mkDerivation rec {
  name = "blueman-1.21";
   
  src = fetchurl {
    url = "http://download.tuxfamily.org/blueman/${name}.tar.gz";
    sha256 = "1bz31w0cqcl77r7vfjwm9c4gmk4hvq3nqn1pjnd5qndia2mhs846";
  };

  configureFlags = "--disable-polkit";

  buildInputs =
    [ pkgconfig intltool python pyrex pygobject pygtk notify pythonDBus
      bluez glib gtk libstartup_notification makeWrapper
    ];

  # !!! Ugly.
  PYTHONPATH = "${pygobject}/lib/${python.libPrefix}/site-packages/gtk-2.0:${pygtk}/lib/${python.libPrefix}/site-packages/gtk-2.0:${notify}/lib/${python.libPrefix}/site-packages/gtk-2.0";

  postInstall =
    ''
      # Create wrappers that set the environment correctly.
      for i in $out/bin/* $out/libexec/*; do
          wrapProgram $i \
              --set PYTHONPATH "$(toPythonPath $out):$PYTHONPATH" \
              --prefix PATH : ${xdg_utils}/bin
      done
    ''; # */

  meta = {
    homepage = http://blueman-project.org/;
    description = "GTK+-based Bluetooth Manager";
  };
}
