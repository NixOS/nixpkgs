{ stdenv, fetchurl, getopt, libjpeg, libpng12, libungif }:

stdenv.mkDerivation rec {
  name = "fbv-1.0b";

  src = fetchurl {
    url = "http://s-tech.elsat.net.pl/fbv/${name}.tar.gz";
    sha256 = "0g5b550vk11l639y8p5sx1v1i6ihgqk0x1hd0ri1bc2yzpdbjmcv";
  };

  buildInputs = [ getopt libjpeg libpng12 libungif ];

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/{bin,man/man1}
  '';

  meta = with stdenv.lib; {
    description = "View pictures on a linux framebuffer device";
    homepage = http://s-tech.elsat.net.pl/fbv/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
