{ lib, stdenv, fetchFromGitHub, python, mutagen, wrapPython, opusTools, mpg123 }:

let version = "0.12.2"; in
stdenv.mkDerivation rec {
  pname = "dir2opus";
  inherit version;

  pythonPath = [ mutagen ];
  buildInputs = [ wrapPython ];
  propagatedBuildInputs = [ opusTools mpg123 ];

  src = fetchFromGitHub {
    owner = "ehmry";
    repo = "dir2opus";
    rev = version;
    hash = "sha256-ZEsXwqxikWxFOz99wTI3rEK/rEYA+BSWGrCwW4q+FFc=";
  };

  postPatch = "sed -i -e 's|#!/usr/bin/python|#!${python}/bin/python|' dir2opus";

  installPhase =
    ''
      mkdir -p $out/bin $out/share/man/man1
      cp dir2opus $out/bin
      cp dir2opus.1 $out/share/man/man1
    '';

  postFixup = "wrapPythonPrograms";

  meta = with lib; {
    homepage = "https://github.com/ehmry/dir2opus";
    maintainers = [ maintainers.ehmry ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
