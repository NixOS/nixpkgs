{ lib, stdenv, fetchurl, autoPatchelfHook, bzip2 }:

stdenv.mkDerivation rec {
  pname = "fastnetmon-advanced";
  version = "2.0.336";

  src = fetchurl {
    url = "https://repo.fastnetmon.com/fastnetmon_ubuntu_jammy/pool/fastnetmon/f/fastnetmon/fastnetmon_${version}_amd64.deb";
    hash = "sha256-qbGYvBaIMnpoyfBVfcCY16vlOaYyE4MPdnkwWohBukA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    bzip2
  ];

  unpackPhase = ''
    ar xf $src
    tar xf data.tar.xz

    # unused libraries, which have additional dependencies
    rm opt/fastnetmon/libraries/gcc1210/lib/libgccjit.so.0.0.1
    rm opt/fastnetmon/libraries/poco_1_10_0/lib/libPocoCryptod.so.70
    rm opt/fastnetmon/libraries/poco_1_10_0/lib/libPocoCrypto.so.70
    rm opt/fastnetmon/libraries/poco_1_10_0/lib/libPocoJWTd.so.70
    rm opt/fastnetmon/libraries/poco_1_10_0/lib/libPocoJWT.so.70
    rm opt/fastnetmon/libraries/wkhtmltopdf-0.12.3/wkhtmltox/lib/libwkhtmltox.so.0.12.3
  '';

  installPhase = ''
    mkdir -p $out/libexec/fastnetmon
    cp -r opt/fastnetmon/app/bin $out/bin
    cp -r opt/fastnetmon/libraries $out/libexec/fastnetmon

    addAutoPatchelfSearchPath $out/libexec/fastnetmon/libraries
  '';

  meta = with lib; {
    description = "A high performance DDoS detector / sensor - commercial edition";
    homepage = "https://fastnetmon.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ yuka ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
