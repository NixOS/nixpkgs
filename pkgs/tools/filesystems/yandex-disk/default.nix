{ stdenv, fetchurl, writeText, zlib, rpmextract, patchelf, which }:

assert stdenv.isLinux;

let
  p = if stdenv.is64bit then {
      arch = "x86_64";
      gcclib = "${stdenv.cc.cc}/lib64";
      sha256 = "0k05ybvnv0zx4vfx55jyhia38qqysaj68mapq0gwgf74k3a943g2";
    }
    else {
      arch = "i386";
      gcclib = "${stdenv.cc.cc}/lib";
      sha256 = "09z9idmp7idcq0alwkla9kal9h82dx11jqh678lc4rviqggxzxhp";
    };
in 
stdenv.mkDerivation rec {

  name = "yandex-disk-${version}";
  version = "0.1.5.948";

  src = fetchurl {
    url = "http://repo.yandex.ru/yandex-disk/rpm/stable/${p.arch}/${name}-1.fedora.${p.arch}.rpm";
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
    homepage = http://help.yandex.com/disk/cli-clients.xml;
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

