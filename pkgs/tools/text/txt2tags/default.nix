{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  version = "2.6";
  name = "txt2tags-${version}";

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
    url = "http://txt2tags.googlecode.com/files/${name}.tgz";
    sha256 = "0p5hql559pk8v5dlzgm75yrcxwvz4z30f1q590yzng0ghvbnf530";
  };

  meta = {
    homepage = http://txt2tags.org/;
    description = "A KISS markup language";
    license  = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ kovirobi ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
