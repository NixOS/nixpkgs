{ lib, stdenv, fetchurl, autoPatchelfHook, bzip2 }:

stdenv.mkDerivation rec {
  pname = "fastnetmon-advanced";
  version = "2.0.335";

  src = fetchurl {
    url = "https://repo.fastnetmon.com/fastnetmon_ubuntu_jammy/pool/fastnetmon/f/fastnetmon/fastnetmon_${version}_amd64.deb";
    hash = "sha256-2WdCQX0AiLTPGM9flVSXgKMrTGCwSXk9IfyS5SRKroY=";
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

    # "These binaries are not part of FastNetMon and we shipped them by accident. They will be removed in next stable build"
    rm opt/fastnetmon/app/bin/{generate_rsa_keys,license_app,fastnetmon_license_server}

    # ships with both 2_0_0 and 2_3_0 but the shared objects are not versioned and only 2_3_0 has the necessary symbols
    rm -rf opt/fastnetmon/libraries/libclickhouse_2_0_0/

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
