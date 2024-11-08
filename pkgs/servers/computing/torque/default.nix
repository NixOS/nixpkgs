{
  lib,
  stdenv,
  fetchFromGitHub,

  autoreconfHook,
  pkg-config,
  flex,
  bison,

  openssl,
  groff,
  libxml2,
  util-linux,
  libtool,
  which,
  coreutils,
  boost,
  zlib,
}:

stdenv.mkDerivation {
  pname = "torque";
  version = "6.1.3h2";

  src = fetchFromGitHub {
    owner = "adaptivecomputing";
    repo = "torque";
    # branch 6.1.3h2, as they aren't pushing tags
    # https://github.com/adaptivecomputing/torque/issues/467
    rev = "458883319157cfc5c509046d09f9eb8e68e8d398";
    sha256 = "1b56bc5j9wg87kcywzmhf7234byyrwax9v1pqsr9xmv2x7saakrr";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    flex
    bison
    libxml2
  ];

  buildInputs = [
    openssl
    groff
    libxml2
    util-linux
    libtool
    which
    boost
    zlib
  ];

  enableParallelBuilding = true;

  # added to fix build with gcc7
  env.NIX_CFLAGS_COMPILE = "-Wno-error -fpermissive";

  postPatch = ''
    substituteInPlace Makefile.am \
      --replace-fail "contrib/init.d contrib/systemd" ""
    substituteInPlace src/cmds/Makefile.am \
      --replace-fail "/etc/" "$out/etc/"
    substituteInPlace src/mom_rcp/pathnames.h \
      --replace-fail /bin/cp ${coreutils}/bin/cp
    substituteInPlace src/resmom/requests.c \
      --replace-fail /bin/cp ${coreutils}/bin/cp
  '';

  preConfigure = ''
    # fix broken libxml2 detection
    sed -i '/xmlLib\=/c\xmlLib=xml2' ./configure

    for s in fifo cray_t3e dec_cluster msic_cluster sgi_origin umn_cluster; do
      substituteInPlace src/scheduler.cc/samples/$s/Makefile.in \
        --replace-fail "schedprivdir = " "schedprivdir = $out/"
    done

    for f in $(find ./ -name Makefile.in); do
      echo patching $f...
      sed -i $f -e '/PBS_MKDIRS/d' -e '/chmod u+s/d'
    done

    patchShebangs buildutils
  '';

  postInstall = ''
    install -Dm755 torque.setup buildutils/pbs_mkdirs -t $out/bin/
  '';

  meta = with lib; {
    homepage = "http://www.adaptivecomputing.com/products/open-source/torque";
    description = "Resource management system for submitting and controlling jobs on supercomputers, clusters, and grids";
    platforms = platforms.linux;
    license = "TORQUEv1.1";
  };
}
