{ stdenv, lib, makeWrapper, fetchFromGitHub
, bc, coreutils, file, gawk, ghostscript, gnused, imagemagick, zip }:

let
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

in stdenv.mkDerivation rec {
  pname = "pdf2odt";
  version = "20170207";

  src = fetchFromGitHub {
    owner  = "gutschke";
    repo   = "pdf2odt";
    rev    = "4533bd14306c30c085001db59dbb8114ea09c360";
    sha256 = "14f9r5f0g6jzanl54jv86ls0frvspka1p9c8dy3fnriqpm584j0r";
  };

  nativeBuildInputs = [ makeWrapper ];

  patches = [ ./use_mktemp.patch ];

  installPhase = ''
    install -Dm0755 pdf2odt           -t $out/bin
    install -Dm0644 README.md LICENSE -t $out/share/doc/pdf2odt

    ln -rs $out/bin/pdf2odt $out/bin/pdf2ods

    wrapProgram $out/bin/pdf2odt \
      --prefix PATH : ${path}
  '';

  meta = with lib; {
    description = "PDF to ODT format converter";
    homepage    = "https://github.com/gutschke/pdf2odt";
    license     = licenses.mit;
    platforms   = platforms.all;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
