{ lib, stdenv, fetchFromGitHub, python3, libreoffice-unwrapped, asciidoc, makeWrapper
# whether to install odt2pdf/odt2doc/... symlinks to unoconv
, installSymlinks ? true
}:

# IMPORTANT: unoconv must use the same python version as libreoffice (unless it
# will not be able to load the pyuno module from libreoffice).

stdenv.mkDerivation rec {
  pname = "unoconv";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "unoconv";
    repo = "unoconv";
    rev = version;
    sha256 = "1akx64686in8j8arl6vsgp2n3bv770q48pfv283c6fz6wf9p8fvr";
  };

  nativeBuildInputs = [ asciidoc makeWrapper ];

  preBuild = ''
    makeFlags=prefix="$out"
  '';

  postInstall = ''
    sed -i "s|/usr/bin/env python.*|${python3}/bin/${python3.executable}|" "$out/bin/unoconv"
    wrapProgram "$out/bin/unoconv" --set UNO_PATH "${libreoffice-unwrapped}/lib/libreoffice/program/"
  '' + lib.optionalString installSymlinks ''
    make install-links prefix="$out"
  '';

  meta = with lib; {
    description = "Convert between any document format supported by LibreOffice/OpenOffice";
    homepage = "http://dag.wieers.com/home-made/unoconv/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
