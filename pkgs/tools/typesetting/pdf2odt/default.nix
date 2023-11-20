{ lib
, resholve
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

resholve.mkDerivation rec {
  pname = "pdf2odt";
  version = "unstable-2022-08-27";

  src = fetchFromGitHub {
    owner = "gutschke";
    repo = "pdf2odt";
    rev = "a05fbdebcc39277d905d1ae66f585a19f467b406";
    hash = "sha256-995iF5Z1V4QEXeXUB8irG451TXpQBHZThJcEfHwfRtE=";
  };

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
    homepage = "https://github.com/gutschke/pdf2odt";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
