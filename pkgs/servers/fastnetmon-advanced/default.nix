{ lib, stdenv, fetchurl, autoPatchelfHook, bzip2 }:

stdenv.mkDerivation rec {
  pname = "fastnetmon-advanced";
  version = "2.0.350";

  src = fetchurl {
    url = "https://repo.fastnetmon.com/fastnetmon_ubuntu_jammy/pool/fastnetmon/f/fastnetmon/fastnetmon_${version}_amd64.deb";
    hash = "sha256-rd0xdpENsdH8jOoUkQHW8/fXE4zEjQemFT4Q2tXjtT8=";
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

    # both clickhouse 2.0.0 and 2.3.0 libs are included, without versioning it will by
    # default choose the first it finds, but we need 2.3.0 otherwise the fastnetmon
    # binary will be missing symbols
    rm -r opt/fastnetmon/libraries/libclickhouse_2_0_0

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

    readlink usr/sbin/gobgpd
    readlink usr/bin/gobgp

    ln -s $(readlink usr/sbin/gobgpd | sed "s:/opt/fastnetmon:$out/libexec/fastnetmon:") $out/bin/fnm-gobgpd
    ln -s $(readlink usr/bin/gobgp | sed "s:/opt/fastnetmon:$out/libexec/fastnetmon:") $out/bin/fnm-gobgp

    addAutoPatchelfSearchPath $out/libexec/fastnetmon/libraries
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    set +o pipefail
    $out/bin/fastnetmon 2>&1 | grep "Can't open log file"
    $out/bin/fcli 2>&1 | grep "Please run this tool with root rights"
    $out/bin/fnm-gobgp --help 2>&1 | grep "Available Commands"
    $out/bin/fnm-gobgpd --help 2>&1 | grep "Application Options"
  '';

  meta = with lib; {
    description = "A high performance DDoS detector / sensor - commercial edition";
    homepage = "https://fastnetmon.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = teams.wdz.members;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
