{ stdenv, lib, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "stt";
  version = "0.9.3";

  src = fetchurl {
    url = "https://github.com/coqui-ai/STT/releases/download/v${version}/native_client.tf.Linux.tar.xz";
    sha256 = "0axwys8vis4f0m7d1i2r3dfqlc8p3yj2nisvc7pdi5qs741xgy8w";
  };
  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    install -D stt $out/bin/stt
    install -D coqui-stt.h $out/include/coqui-stt.h
    install -D libstt.so $out/lib/libstt.so
  '';

  meta = with lib; {
    homepage = "https://github.com/coqui-ai/STT";
    description = "Deep learning toolkit for Speech-to-Text, battle-tested in research and production";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
