{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, xz
, bzip2
}:

stdenv.mkDerivation rec {
  pname = "stt";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/coqui-ai/STT/releases/download/v${version}/native_client.tflite.Linux.tar.xz";
    sha256 = "JsMrSNE0KlKpI998wPY6dMTyTggRtqu4JmucBmgirNs=";
  };
  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    xz # for lzma
    bzip2
  ];

  installPhase = ''
    runHook preInstall

    install -D stt $out/bin/stt
    install -D coqui-stt.h $out/include/coqui-stt.h
    install -D libsox.so.3 $out/lib/libsox.so.3
    install -D libkenlm.so $out/lib/libkenlm.so
    install -D libstt.so $out/lib/libstt.so

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/coqui-ai/STT";
    description = "Deep learning toolkit for Speech-to-Text, battle-tested in research and production";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
