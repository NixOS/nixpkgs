{ stdenv, lib, fetchFromGitLab, python3, intltool, gtk3, gobject-introspection, gnome }:

python3.pkgs.buildPythonApplication rec {
  pname = "onioncircuits";
  version = "0.7";

  # uses distutils, but in a way setuptools doesn't like
  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.tails.boum.org";
    owner = "tails";
    repo = pname;
    rev = version;
    hash = "sha256-O4tSbKBTmve4u8bXVg128RLyuxvTbU224JV8tQ+aDAQ=";
  };

  nativeBuildInputs = [ intltool python3.pkgs.distutils_extra ];
  buildInputs = [ gtk3 gobject-introspection ];
  propagatedBuildInputs = with python3.pkgs; [ stem pygobject3 ];

  postFixup = ''
    wrapProgram "$out/bin/onioncircuits" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix XDG_DATA_DIRS : "$out/share:${gnome.adwaita-icon-theme}/share"
  '';

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    python setup.py install --home="$out"
    runHook postInstall
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://tails.boum.org";
    description = "GTK application to display Tor circuits and streams";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}

