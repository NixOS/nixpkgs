{ lib, stdenv, fetchFromGitHub, AppKit, Cocoa }:

let
  pname = "pngpaste";
  version = "0.2.3";
in stdenv.mkDerivation {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "jcsalterego";
    repo = pname;
    rev = version;
    sha256 = "uvajxSelk1Wfd5is5kmT2fzDShlufBgC0PDCeabEOSE=";
  };

  buildInputs = [ AppKit Cocoa ];

  installPhase = ''
    mkdir -p $out/bin
    cp pngpaste $out/bin
  '';

  meta = with lib; {
    description = "Paste image files from clipboard to file on MacOS";
    longDescription = ''
      Paste PNG into files on MacOS, much like pbpaste does for text.
      Supported input formats are PNG, PDF, GIF, TIF, JPEG.
      Supported output formats are PNG, GIF, JPEG, TIFF.  Output
      formats are determined by the provided filename extension,
      falling back to PNG.
    '';
    homepage = "https://github.com/jcsalterego/pngpaste";
    changelog = "https://github.com/jcsalterego/pngpaste/raw/${version}/CHANGELOG.md";
    platforms = platforms.darwin;
    license = licenses.bsd2;
    maintainers = with maintainers; [ samw ];
  };
}
