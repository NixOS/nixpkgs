{ stdenv, lib, makeWrapper, fetchFromGitHub
, bc, coreutils, file, gawk, ghostscript, gnused, imagemagick, zip }:

stdenv.mkDerivation rec {
  version = "2014-12-17";
  name = "pdf2odt-${version}";

  src = fetchFromGitHub {
    owner = "gutschke";
    repo = "pdf2odt";
    rev = "master";
    sha256 = "14f9r5f0g6jzanl54jv86ls0frvspka1p9c8dy3fnriqpm584j0r";
  };

  dontStrip = true;

  nativeBuildInputs = [ makeWrapper ];

  path = lib.makeBinPath [
    bc
    coreutils
    file
    gawk
    ghostscript
    gnused
    imagemagick
    zip
  ];

  patches = [ ./use_mktemp.patch ];

  installPhase = ''
    mkdir -p $out/bin $out/share/doc

    install -m0755 pdf2odt $out/bin/pdf2odt
    ln -rs $out/bin/pdf2odt $out/bin/pdf2ods

    install -m0644 README.md LICENSE -t $out/share/doc

    wrapProgram $out/bin/pdf2odt --prefix PATH : ${path}
  '';

  meta = with stdenv.lib; {
    description = "PDF to ODT format converter";
    homepage = http://github.com/gutschke/pdf2odt;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ peterhoeg ];
    inherit version;
  };
}
