{ stdenv, fetchurl, python3, libreoffice-unwrapped, asciidoc, makeWrapper
# whether to install odt2pdf/odt2doc/... symlinks to unoconv
, installSymlinks ? true
}:

# IMPORTANT: unoconv must use the same python version as libreoffice (unless it
# will not be able to load the pyuno module from libreoffice).

stdenv.mkDerivation rec {
  name = "unoconv-0.6";

  src = fetchurl {
    url = "http://dag.wieers.com/home-made/unoconv/${name}.tar.gz";
    sha256 = "1m3kv942zf5rzyrbkil0nhmyq9mm3007y64bb3s7w88mhr5n23kr";
  };

  buildInputs = [ asciidoc makeWrapper ];

  # We need to use python3 because libreoffice 4.x uses it. This patch comes
  # from unoconv.git, so it will be a part of the next release.
  patches = [ ./unoconv-python3.patch ];

  preBuild = ''
    makeFlags=prefix="$out"
  '';

  postInstall = ''
    sed -i "s|/usr/bin/env python.*|${python3}/bin/${python3.executable}|" "$out/bin/unoconv"
    wrapProgram "$out/bin/unoconv" --set UNO_PATH "${libreoffice-unwrapped}/lib/libreoffice/program/"
  '' + (if installSymlinks then ''
    make install-links prefix="$out"
  '' else "");

  meta = with stdenv.lib; {
    description = "Convert between any document format supported by LibreOffice/OpenOffice";
    homepage = http://dag.wieers.com/home-made/unoconv/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
