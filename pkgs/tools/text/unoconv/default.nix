{ lib, stdenv, fetchFromGitHub, python3, libreoffice-unwrapped, asciidoc, makeWrapper
# whether to install odt2pdf/odt2doc/... symlinks to unoconv
, installSymlinks ? true
}:

let
  libreoffice = libreoffice-unwrapped.override {
    inherit python3;
  };
in python3.pkgs.buildPythonApplication rec {
  pname = "unoconv";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "unoconv";
    repo = "unoconv";
    rev = version;
    sha256 = "1akx64686in8j8arl6vsgp2n3bv770q48pfv283c6fz6wf9p8fvr";
  };

  patches = [
    ./program-name.patch
  ];

  nativeBuildInputs = [ asciidoc makeWrapper ];

  makeWrapperArgs = [
    "--set" "UNO_PATH" "${libreoffice}/lib/libreoffice/program/"
    "--set" "NIX_PROGRAM_NAME" "\\$0"
  ];

  postInstall = lib.optionalString installSymlinks ''
    make install-links prefix="$out"
  '';

  meta = with lib; {
    description = "Convert between any document format supported by LibreOffice/OpenOffice";
    homepage = "http://dag.wieers.com/home-made/unoconv/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor dotlambda ];
  };
}
