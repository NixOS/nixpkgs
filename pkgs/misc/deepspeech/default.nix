{ stdenv, lib, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "deepspeech";
  version = "0.9.3";

  src = fetchurl {
    url = "https://github.com/mozilla/DeepSpeech/releases/download/v${version}/native_client.amd64.cpu.linux.tar.xz";
    sha256 = "1qy2gspprcxi76jk06ljp028xl0wkk1m3mqaxyf5qbhhfbvvpfap";
  };
  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    install -D deepspeech $out/bin/deepspeech
    install -D deepspeech.h $out/include/deepspeech.h
    install -D libdeepspeech.so $out/lib/libdeepspeech.so
  '';

  meta = with lib; {
    homepage = https://github.com/mozilla/DeepSpeech;
    description = "Open source embedded (offline, on-device) speech-to-text engine, which can run in real time on broad range of devices";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
