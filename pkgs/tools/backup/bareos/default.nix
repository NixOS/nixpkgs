{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, rpcsvc-proto
, libtirpc
, gtest
, linux-pam
, readline
, openssl
, python3
, ncurses
, postgresql
, lzo
, systemd
, zlib
, jansson
, acl
, glusterfs
, libceph
, libcap
, libxml2
, json_c
}:

with lib;
let
  pythonMajMin = lib.versions.majorMinor (lib.getVersion python3);
in
stdenv.mkDerivation rec {
  pname = "bareos";
  version = "20.0.3";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "bareos";
    repo = "bareos";
    rev = "Release/${version}";
    name = "${pname}-${version}-src";
    sha256 = "sha256-fqSrLDcm8Yb53Jt+K5xywOc0UAurzVChmi4eDOW2NVQ=";
  };

  nativeBuildInputs = [ cmake pkg-config rpcsvc-proto ];
  buildInputs = [
    acl
    glusterfs
    gtest
    jansson
    libcap
    libceph.dev
    libtirpc.dev
    linux-pam
    lzo
    ncurses
    openssl
    postgresql
    python3
    readline
    systemd.dev
    zlib
    libxml2.dev
    json_c.dev
  ];

  postPatch = ''
    patchShebangs systemtests/scripts/generate_minio_certs.sh.in

    substituteInPlace core/platforms/CMakeLists.txt --replace archlinux unknown

    for plugin in dird stored filed; do
      substituteInPlace core/src/plugins/''${plugin}/python/CMakeLists.txt --replace 'DESTINATION ''${Python3_SITELIB}' "DESTINATION $out/lib/python${pythonMajMin}/site-packages"
    done

    substituteInPlace core/CMakeLists.txt --replace /usr/include/tirpc ${libtirpc.dev}/include/tirpc
    substituteInPlace core/src/droplet/cmake/Findjsonc.cmake --replace /usr/include ${json_c.dev}/include

    substituteInPlace core/src/droplet/libdroplet/src/utils.c --replace attr/xattr.h sys/xattr.h
    substituteInPlace core/src/droplet/libdroplet/src/backend/posix/reqbuilder.c --replace attr/xattr.h sys/xattr.h
  '';

  cmakeFlags = [
    # Make paths relative to build dir, for determinism.
    "-DDEBUG_PREFIX_MAP=ON"
    # Postgres is the only supported database remaining, mysql and
    # sqlite are both obsoleted.
    "-Dpostgresql=yes"
    # scsi-crypto lets bareos manage hardware encryption on tape
    # drives.
    "-Dscsi-crypto=yes"
    # Build and install systemd units.
    "-Dsystemd=yes"
    "-DSYSTEMD_UNITDIR=lib/systemd/system"
  ];

  meta = with lib; {
    homepage = "https://www.bareos.com/";
    description = "A networked backup solution which preserves, archives, and recovers data from all major operating systems.";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.danderson ];
  };
}
