{ stdenv, lib, fetchurl, makeWrapper, python3, gettext
, pyqt5, setuptools, requests
}:

stdenv.mkDerivation rec {
  pname = "fs-uae-launcher";
  version = "3.0.5";

  src = fetchurl {
    url = "https://fs-uae.net/stable/${version}/${pname}-${version}.tar.gz";
    sha256 = "1dknra4ngz7bpppwqghmza1q68pn1yaw54p9ba0f42zwp427ly97";
  };

  makeFlags = [ "prefix=$(out)" ];
  nativeBuildInputs = [ makeWrapper python3 gettext ];
  buildInputs = [ pyqt5 setuptools requests ];
  postInstall = ''
    wrapProgram $out/bin/fs-uae-launcher --set PYTHONPATH "$PYTHONPATH"
  '';

  meta = {
    description = "Graphical front-end for the FS-UAE emulator";
    license = lib.licenses.gpl2Plus;
    homepage = "https://fs-uae.net";
    maintainers = with lib; [ maintainers.sander ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
