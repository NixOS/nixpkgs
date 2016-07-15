{ stdenv, fetchurl, e2fsprogs }:

stdenv.mkDerivation rec {
  name = "zerofree-${version}";
  version = "1.0.4";

  src = fetchurl {
    url = "http://frippery.org/uml/${name}.tgz";
    sha256 = "0f38mvn3wfacapayl54q04qlz4in417pfm6gapgm7dhyjs9y5yd7";
  };

  buildInputs = [ e2fsprogs ];

  installPhase = ''
    mkdir -p $out/bin
    cp zerofree $out/bin
'';

  meta = {
    homepage = http://frippery.org/uml/index.html;
    description = "Zero free blocks from ext2, ext3 and ext4 file-systems";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.theuni ];
  };
}
