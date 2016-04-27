{ stdenv, fetchurl, python, mutagen, wrapPython, opusTools, mpg123 }:

let version = "0.12.2"; in
stdenv.mkDerivation rec {
  name = "dir2opus-${version}";

  pythonPath = [ mutagen ];
  buildInputs = [ wrapPython ];
  propagatedBuildInputs = [ opusTools mpg123 ];

  src = fetchurl {
    url = "https://github.com/ehmry/dir2opus/archive/${version}.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "0bl8fa9zhccihnj1v3lpz5jb737frf9za06xb7j5rsjws6xky80d";
  };

  postPatch = "sed -i -e 's|#!/usr/bin/python|#!${python}/bin/python|' dir2opus";

  installPhase =
    ''
      mkdir -p $out/bin $out/share/man/man1
      cp dir2opus $out/bin
      cp dir2opus.1 $out/share/man/man1
    '';

  postFixup = "wrapPythonPrograms";

  meta = with stdenv.lib;
    { homepage = https://github.com/ehmry/dir2opus;
      maintainers = [ maintainers.ehmry ];
      license = licenses.gpl2;
    };
}
