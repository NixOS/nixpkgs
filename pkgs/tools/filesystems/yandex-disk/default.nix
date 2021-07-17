{ lib, stdenv, fetchurl, writeText, zlib, rpmextract, patchelf, which }:

let
  p = if stdenv.is64bit then {
      arch = "x86_64";
      gcclib = "${stdenv.cc.cc.lib}/lib64";
      sha256 = "d61bf5c9bd285246f0e47fa529049e21cc187eb3";
    }
    else {
      arch = "i386";
      gcclib = "${stdenv.cc.cc.lib}/lib";
      sha256 = "929f530a7b31f95a7ae3e6a2a40c60f2f4f16fee";
    };
in
stdenv.mkDerivation rec {

  pname = "yandex-disk";
  version = "0.1.6.1074-1";

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

    mkdir -p $out/share/bash-completion/completions
    cp -r -t $out/bin usr/bin/*
    cp -r -t $out/share usr/share/*
    cp -r -t $out/share/bash-completion/completions etc/bash_completion.d/*

    sed -i 's@have@${which}/bin/which >/dev/null 2>\&1@' \
      $out/share/bash-completion/completions/yandex-disk-completion.bash

    ${patchelf}/bin/patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${zlib.out}/lib:${p.gcclib}" \
      $out/bin/yandex-disk
  '';

  meta = {
    homepage = "https://help.yandex.com/disk/cli-clients.xml";
    description = "A free cloud file storage service";
    maintainers = with lib.maintainers; [ smironov jagajaga ];
    platforms = ["i686-linux" "x86_64-linux"];
    license = lib.licenses.unfree;
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
