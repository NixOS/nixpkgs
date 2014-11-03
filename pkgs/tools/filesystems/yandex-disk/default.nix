{ stdenv, fetchurl, writeText, zlib, rpmextract, patchelf, which }:

assert stdenv.isLinux;

let
  p = if stdenv.is64bit then {
      arch = "x86_64";
      gcclib = "${stdenv.gcc.gcc}/lib64";
      sha256 = "09kw7f0qsvx3vx1c1zb117yf3yk7kkz66agspz5xx9b0zh6i82jw";
    }
    else {
      arch = "i386";
      gcclib = "${stdenv.gcc.gcc}/lib";
      sha256 = "0f2230c91120f05159281b39c620ab6bad6559ce8a17a0874d0a82350ebba426";
    };
in 
stdenv.mkDerivation rec {

  name = "yandex-disk-0.1.4.504";

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

