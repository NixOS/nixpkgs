{ stdenv, fetchgit, pythonPackages, intltool, gtk3, gobject-introspection, defaultIconTheme }:

pythonPackages.buildPythonApplication rec {
  name = "onioncircuits-${version}";
  version = "0.5";

  src = fetchgit {
    url = "https://git-tails.immerda.ch/onioncircuits/";
    rev = version;
    sha256 = "13mqif9b9iajpkrl9ijspdnvy82kxhprxd5mw3njk68rcn4z2pcm";
  };

  buildInputs = [ intltool gtk3 gobject-introspection ];
  propagatedBuildInputs =  with pythonPackages; [ stem distutils_extra pygobject3 ];

  postFixup = ''
    wrapProgram "$out/bin/onioncircuits" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix XDG_DATA_DIRS : "$out/share:${defaultIconTheme}/share"
  '';

  meta = with stdenv.lib; {
    homepage = https://tails.boum.org;
    description = "GTK application to display Tor circuits and streams";
    license = licenses.gpl3;
    maintainers = [ maintainers.phreedom ];
  };
}

