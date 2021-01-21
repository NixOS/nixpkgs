{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  version = "2.6";
  pname = "txt2tags";

  dontBuild = true;

  # Python script, needs the interpreter
  propagatedBuildInputs = [ python ];

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/doc"
    mkdir -p "$out/share/man/man1/"
    sed '1s|/usr/bin/env python|${python}/bin/python|' < txt2tags > "$out/bin/txt2tags"
    chmod +x "$out/bin/txt2tags"
    gzip - < doc/manpage.man > "$out/share/man/man1/txt2tags.1.gz"
    cp doc/userguide.pdf "$out/share/doc"
    cp -r extras/ samples/ test/ "$out/share"
  '';

  src = fetchurl {
    url = "https://github.com/txt2tags/old/raw/master/${pname}-${version}.tgz";
    sha256 = "601467d7860f3cfb3d48050707c6277ff3ceb22fa7be4f5bd968de540ac5b05c";
  };

  meta = {
    homepage = "https://txt2tags.org/";
    description = "A KISS markup language";
    license  = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ kovirobi ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
