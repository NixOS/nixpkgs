{ lib
, resholvePackage
, fetchFromGitHub
, bc
, coreutils
, file
, gawk
, ghostscript
, gnused
, imagemagick
, zip
, bash
, findutils
}:

resholvePackage rec {
  pname = "pdf2odt";
  version = "20170207";

  src = fetchFromGitHub {
    owner  = "gutschke";
    repo   = "pdf2odt";
    rev    = "4533bd14306c30c085001db59dbb8114ea09c360";
    sha256 = "14f9r5f0g6jzanl54jv86ls0frvspka1p9c8dy3fnriqpm584j0r";
  };

  patches = [ ./use_mktemp.patch ];

  installPhase = ''
    install -Dm0755 pdf2odt           -t $out/bin
    install -Dm0644 README.md LICENSE -t $out/share/doc/pdf2odt

    ln -rs $out/bin/pdf2odt $out/bin/pdf2ods
  '';
  solutions = {
    default = {
      scripts = [ "bin/pdf2odt" ];
      interpreter = "${bash}/bin/bash";
      inputs = [
        coreutils
        bc
        file
        imagemagick
        gawk
        gnused
        ghostscript
        zip
        findutils
      ];
    };
  };

  meta = with lib; {
    description = "PDF to ODT format converter";
    homepage    = "https://github.com/gutschke/pdf2odt";
    license     = licenses.mit;
    platforms   = platforms.all;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
