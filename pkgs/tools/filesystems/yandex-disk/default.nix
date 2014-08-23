{ stdenv, fetchurl, writeText, zlib, rpm, cpio, patchelf, which }:
let
  p = if stdenv.is64bit then {
      arch = "x86_64";
      gcclib = "${stdenv.gcc.gcc}/lib64";
      sha256 = "1fmmlvvh97d60n9k08bn4k6ghwr3yhs8sib82025nwpw1sq08vim";
    }
    else {
      arch = "i386";
      gcclib = "${stdenv.gcc.gcc}/lib";
      sha256 = "3940420bd9d1fe1ecec1a117bfd9d21d545bca59f5e0a4364304ab808c976f7f";
    };
in 
stdenv.mkDerivation rec {

  name = "yandex-disk-0.1.2.481";

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
    ${rpm}/bin/rpm2cpio $src | ${cpio}/bin/cpio -imd

    cp -r -t $out/bin usr/bin/*
    cp -r -t $out/share usr/share/*
    cp -r -t $out/etc etc/*

    sed -i 's@have@${which}/bin/which >/dev/null 2>\&1@' \
      $out/etc/bash_completion.d/yandex-disk-completion.bash

    ${patchelf}/bin/patchelf \
      --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath "${zlib}/lib:${p.gcclib}" \
      $out/bin/yandex-disk
  '';

  meta = {
    homepage = http://help.yandex.com/disk/cli-clients.xml;
    description = "Yandex.Disk is a free cloud file storage service";
    maintainers = with stdenv.lib.maintainers; [smironov];
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

