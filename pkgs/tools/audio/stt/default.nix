{ stdenv, lib, fetchurl, autoPatchelfHook, bzip2, lzma }:

stdenv.mkDerivation rec {
  pname = "stt";
  version = "1.4.0";

  src = fetchurl {
    url = "https://github.com/coqui-ai/STT/releases/download/v${version}/native_client.tflite.Linux.tar.xz";
    hash = "sha256-RVYc64pLYumQoVUEFZdxfUUaBMozaqgD0h/yiMaWN90=";
  };
  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    bzip2
    lzma
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    install -D stt $out/bin/stt
    install -D coqui-stt.h $out/include/coqui-stt.h
    install -D libkenlm.so $out/lib/libkenlm.so
    install -D libsox.so.3 $out/lib/libsox.so.3
    install -D libstt.so $out/lib/libstt.so
  '';

  meta = with lib; {
    homepage = "https://github.com/coqui-ai/STT";
    description = "Deep learning toolkit for Speech-to-Text, battle-tested in research and production";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
