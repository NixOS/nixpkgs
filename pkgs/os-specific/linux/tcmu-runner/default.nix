{ lib
, stdenv
, ceph
, cmake
, fetchFromGitHub
, glib
, glusterfs
, gperftools
, kmod
, libnl
, pcre
, pkg-config
, util-linuxMinimal
, zlib
, cephSupport ? true
, glusterSupport ? true
, systemdSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "tcmu-runner";
  version = "unstable-2022-02-21";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "tcmu-runner";
    rev = "364ae611ffdd7c8fb3d1e733563b636bf3b44ba6";
    hash = "sha256-SxAkpOzNB7/csEVfC6ptyyxJ8lu3YnRGiZhk4DsJnBA=";
  };

  postPatch = ''
    # fix install paths, as they are currently hardcoded
    # see also: https://github.com/open-iscsi/tcmu-runner/issues/683
    substituteInPlace CMakeLists.txt \
      --replace " /etc" " \''${CMAKE_INSTALL_PREFIX}/etc" \
      --replace " /usr/" " \''${CMAKE_INSTALL_PREFIX}/"
    for i in *.conf_install.cmake.in; do
      substituteInPlace "$i" \
        --replace " \"/etc" " \"\''${CMAKE_INSTALL_PREFIX}/etc"
    done
    for i in *.service; do
      substituteInPlace "$i" \
        --replace "=/usr/bin/" "=/$out/bin/"
    done
    unset i
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    gperftools # for tcmalloc
    kmod
    libnl
    pcre
    util-linuxMinimal # for libmount
    zlib
  ] ++ lib.optional cephSupport ceph
    ++ lib.optional glusterSupport glusterfs;

  cmakeFlags = lib.optionals systemdSupport [ "-DSUPPORT_SYSTEMD=ON" ];

  meta = with lib; {
    description = "A daemon that handles the userspace side of the LIO TCM-User backstore";
    homepage = "https://github.com/open-iscsi/tcmu-runner";
    maintainers = with maintainers; [ zseri ];
    license = with licenses; [ asl20 lgpl21 ];
    platforms = platforms.linux;
  };
}
