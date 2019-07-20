{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "yuicompressor-${version}";
  version = "2.4.8";
  
  src = fetchurl {
    url = "https://github.com/yui/yuicompressor/releases/download/v${version}/${name}.jar";
    sha256 = "1qjxlak9hbl9zd3dl5ks0w4zx5z64wjsbk7ic73r1r45fasisdrh";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  buildCommand = ''
    mkdir -p $out/{bin,lib}
    ln -s $src $out/lib/yuicompressor.jar
    makeWrapper ${jre}/bin/java $out/bin/yuicompressor --add-flags \
     "-cp $out/lib/yuicompressor.jar com.yahoo.platform.yui.compressor.YUICompressor"
  '';
  
  meta = with stdenv.lib; {
    description = "A JavaScript and CSS minifier";
    homepage = http://yui.github.io/yuicompressor/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.all;
  };
}
