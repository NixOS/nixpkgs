{ stdenv, fetchFromGitiles, fetchFromGitHub, fetchurl, trousers, leveldb, unzip
, scons, pkgconfig, glib, dbus_cplusplus, dbus, protobuf, openssl, snappy, pam
}:

let
  src_chromebase = fetchFromGitiles {
    url = "https://chromium.googlesource.com/chromium/src/base";
    rev = "2dfe404711e15e24e79799516400c61b2719d7af";
    sha256 = "2bd93a3ace4b6767db2c1bd1e16f426c97b8d2133a9cb15f8372b2516cfa65c5";
  };

  src_gmock = fetchurl {
    url = "https://googlemock.googlecode.com/files/gmock-1.7.0.zip";
    sha256 = "0nq98cpnv2jsx2byp4ilam6kydcnziflkc16ikydajmp4mcvpz16";
  };

  src_platform2 = fetchFromGitiles {
    url = "https://chromium.googlesource.com/chromiumos/platform2";
    rev = "e999e989eaa71c3db7314fc7b4e20829b2b5473b";
    sha256 = "15n1bsv6r7cny7arx0hdb223xzzbk7vkxg2r7xajhl4nsj39adjh";
  };

in

stdenv.mkDerivation rec {
  name = "chaps-0.42-6812";
  version = "0.42-6812";

  src = fetchFromGitHub {
    owner = "google";
    repo = "chaps-linux";
    rev = "989aadc45cdb216ca35b0c97d13fc691576fa1d7";
    sha256 = "0chk6pnn365d5kcz6vfqx1d0383ksk97icc0lzg0vvb0kvyj0ff1";
  };

  NIX_CFLAGS_COMPILE = [
    # readdir_r(3) is deprecated in glibc >= 2.24
    "-Wno-error=deprecated-declarations"
    # gcc8 catching polymorphic type error
    "-Wno-error=catch-value"
  ];

  patches = [ ./fix_absolute_path.patch  ./fix_environment_variables.patch  ./fix_scons.patch  ./insert_prefetches.patch ];

  postPatch = ''
    substituteInPlace makefile --replace @@NIXOS_SRC_CHROMEBASE@@ ${src_chromebase}
    substituteInPlace makefile --replace @@NIXOS_SRC_GMOCK@@ ${src_gmock}
    substituteInPlace makefile --replace @@NIXOS_SRC_PLATFORM2@@ ${src_platform2}
    substituteInPlace makefile --replace @@NIXOS_LEVELDB@@ ${leveldb}
    '';

  nativeBuildInputs = [ unzip scons pkgconfig ];

  buildInputs = [ trousers glib dbus_cplusplus dbus protobuf openssl snappy leveldb pam ];

  buildPhase = ''
    make build
    '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${name}/out/chapsd $out/bin/.
    cp ${name}/out/chaps_client $out/bin/.

    mkdir -p $out/lib
    cp ${name}/out/libchaps.so.* $out/lib/.
    mkdir -p $out/lib/security
    cp ${name}/out/pam_chaps.so $out/lib/security/.

    mkdir -p $out/include
    cp -r ${name}/out/chaps $out/include/.

    mkdir -p $out/etc/dbus-1/system.d
    cp ${name}/out/org.chromium.Chaps.conf $out/etc/dbus-1/system.d/.
    mkdir -p $out/etc/dbus-1/system-services
    cp ${name}/platform2/chaps/org.chromium.Chaps.service $out/etc/dbus-1/system-services/.

    mkdir -p $out/usr/share/pam-configs/chaps
    mkdir -p $out/usr/share/man/man8
    cp ${name}/man/* $out/usr/share/man/man8/.
    '';

  meta = with stdenv.lib; {
    description = "PKCS #11 implementation based on trusted platform module (TPM)";
    homepage = https://www.chromium.org/developers/design-documents/chaps-technical-design;
    maintainers = [ maintainers.tstrobel ];
    platforms = [ "x86_64-linux" ];
    license = licenses.bsd3;
    broken = true;  # build failure withn openssl 1.1
  };
}
