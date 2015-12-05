{ stdenv, fetchurl, python, mutagen, wrapPython, opusTools }:

let version = "0.12.1"; in
stdenv.mkDerivation rec {
  name = "dir2opus-${version}";

  pythonPath = [ mutagen ];
  buildInputs = [ wrapPython ];
  propagatedBuildInputs = [ opusTools ];

  src = fetchurl {
    url = "https://github.com/ehmry/dir2opus/archive/${version}.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "1d6x3qfcj5lfmc8gzna1vrr7fl31i86ha8l4nz5987rx57fgwf0q";
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