{ stdenv, lib, fetchgit, python3, intltool, gtk3, gobject-introspection, gnome }:

python3.pkgs.buildPythonApplication rec {
  pname = "onioncircuits";
  version = "0.5";

  src = fetchgit {
    url = "https://git-tails.immerda.ch/onioncircuits/";
    rev = version;
    sha256 = "13mqif9b9iajpkrl9ijspdnvy82kxhprxd5mw3njk68rcn4z2pcm";
  };

  nativeBuildInputs = [ intltool ];
  buildInputs = [ gtk3 gobject-introspection ];
  propagatedBuildInputs =  with python3.pkgs; [ stem distutils_extra pygobject3 ];

  postFixup = ''
    wrapProgram "$out/bin/onioncircuits" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix XDG_DATA_DIRS : "$out/share:${gnome.adwaita-icon-theme}/share"
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://tails.boum.org";
    description = "GTK application to display Tor circuits and streams";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}

