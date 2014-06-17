{ stdenv, fetchurl, gtk, atk, gdk_pixbuf, pango, makeWrapper }:

let
  dynlibPath = stdenv.lib.makeLibraryPath
    [ gtk atk gdk_pixbuf pango ];
in
stdenv.mkDerivation rec {
  name    = "jd-gui-${version}";
  version = "0.3.5";

  src = fetchurl {
    url    = "http://jd.benow.ca/jd-gui/downloads/${name}.linux.i686.tar.gz";
    sha256 = "0jrvzs2s836yvqi41c7fq0gfiwf187qg765b9r1il2bjc0mb3dqv";
  };

  buildInputs = [ makeWrapper ];

  phases = "unpackPhase installPhase";
  unpackPhase = "tar xf ${src}";
  installPhase = ''
    mkdir -p $out/bin && mv jd-gui $out/bin
    wrapProgram $out/bin/jd-gui \
      --prefix LD_LIBRARY_PATH ":" "${dynlibPath}"
  '';

  meta = {
    description = "Fast Java Decompiler with powerful GUI";
    homepage    = "http://jd.benow.ca/";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = [ "i686-linux" ];
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
