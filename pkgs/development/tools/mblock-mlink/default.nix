{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  makeWrapper,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "mblock-mlink";
  version = "1.2.0";

  src = fetchurl {
    url = "https://dl.makeblock.com/mblock5/linux/mLink-${version}-amd64.deb";
    sha256 = "sha256-KLxj81ZjbEvhhaz0seNB4WXX5ybeZ7/WcT1dGfdWle0=";
  };

  unpackPhase = ''
    ${dpkg}/bin/dpkg -x $src $out
  '';

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    mv $out/usr/local/makeblock $out/usr/makeblock
    rmdir $out/usr/local
    mkdir -p $out/bin
    echo $out/usr/makeblock/mLink/mnode $out/usr/makeblock/mLink/app.js > $out/bin/mlink
    chmod +x $out/bin/mlink
  '';

  meta = with lib; {
    description = "Driver for mBlock web version";
    homepage = "https://mblock.makeblock.com/en-us/download/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.mausch ];
  };
}
