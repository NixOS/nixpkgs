{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "ventoy";
  version = "1.0.07";

  src = fetchurl {
    url = "https://github.com/ventoy/Ventoy/releases/download/v${version}/ventoy-${version}-linux.tar.gz";
    sha256 = "13raplng4bls84yfcami69wm7wb53rmv8ml9w8974ssxvidy31vc";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    cp -r . $out
    mkdir -p $out/bin
    makeWrapper $out/Ventoy2Disk.sh $out/bin/ventoy
  '';

  meta = with stdenv.lib; {
    description = "An open source tool to create bootable USB drive for ISO files";
    homepage = "https://ventoy.net";
    license = licenses.gpl3;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.linux;
  };
}
