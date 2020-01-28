{ stdenv, fetchurl, writeText, zlib, rpmextract, patchelf, which }:

let
  p = if stdenv.is64bit then {
      arch = "x86_64";
      gcclib = "${stdenv.cc.cc.lib}/lib64";
      sha256 = "14bpc5ddhxvgfxkxhj5q9z443s7z4nn1zf4k1hxj7rbf13rcpg00";
    }
    else {
      arch = "i386";
      gcclib = "${stdenv.cc.cc.lib}/lib";
      sha256 = "1s829q8gy9xgz0jm7w70aljqs2h49x402blqfr9zvn806aprmrm5";
    };
in
stdenv.mkDerivation rec {

  pname = "yandex-disk";
  version = "0.1.5.1039";

  src = fetchurl {
    url = "https://repo.yandex.ru/yandex-disk/rpm/stable/${p.arch}/${pname}-${version}-1.fedora.${p.arch}.rpm";
    sha256 = p.sha256;
  };

  builder = writeText "builder.sh" ''
    . $stdenv/setup
    mkdir -pv $out/bin
    mkdir -pv $out/share
    mkdir -pv $out/etc

    mkdir -pv unpacked
    cd unpacked
    ${rpmextract}/bin/rpmextract $src

    cp -r -t $out/bin usr/bin/*
    cp -r -t $out/share usr/share/*
    cp -r -t $out/etc etc/*

    sed -i 's@have@${which}/bin/which >/dev/null 2>\&1@' \
      $out/etc/bash_completion.d/yandex-disk-completion.bash

    ${patchelf}/bin/patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${zlib.out}/lib:${p.gcclib}" \
      $out/bin/yandex-disk
  '';

  meta = {
    homepage = https://help.yandex.com/disk/cli-clients.xml;
    description = "A free cloud file storage service";
    maintainers = with stdenv.lib.maintainers; [ smironov jagajaga ];
    platforms = ["i686-linux" "x86_64-linux"];
    license = stdenv.lib.licenses.unfree;
    longDescription = ''
      Yandex.Disk console client for Linux lets you manage files on Disk without
      using a window interface or programs that support WebDAV. The advantages
      of the console client compared to a WebDAV connection:
       * low system resource requirements;
       * faster file reading and writing speeds;
       * faster syncing with Disk's server;
       * no need to be constantly connected to work with files.
    '';
  };
}
