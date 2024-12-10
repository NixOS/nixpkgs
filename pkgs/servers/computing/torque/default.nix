{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  flex,
  bison,
  pkg-config,
  groff,
  libxml2,
  util-linux,
  coreutils,
  file,
  libtool,
  which,
  boost,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "torque";
  version = "6.1.3h2";

  src = fetchFromGitHub {
    owner = "adaptivecomputing";
    repo = pname;
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
  ];

  enableParallelBuilding = true;

  # added to fix build with gcc7
  env.NIX_CFLAGS_COMPILE = "-Wno-error -fpermissive";

  postPatch = ''
    substituteInPlace Makefile.am \
      --replace "contrib/init.d contrib/systemd" ""
    substituteInPlace src/cmds/Makefile.am \
      --replace "/etc/" "$out/etc/"
    substituteInPlace src/mom_rcp/pathnames.h \
      --replace /bin/cp ${coreutils}/bin/cp
    substituteInPlace src/resmom/requests.c \
      --replace /bin/cp ${coreutils}/bin/cp
  '';

  preConfigure = ''
    substituteInPlace ./configure \
      --replace '/usr/bin/file' '${file}/bin/file'

    # fix broken libxml2 detection
    sed -i '/xmlLib\=/c\xmlLib=xml2' ./configure

    for s in fifo cray_t3e dec_cluster msic_cluster sgi_origin umn_cluster; do
      substituteInPlace src/scheduler.cc/samples/$s/Makefile.in \
        --replace "schedprivdir = " "schedprivdir = $out/"
    done

    for f in $(find ./ -name Makefile.in); do
      echo patching $f...
      sed -i $f -e '/PBS_MKDIRS/d' -e '/chmod u+s/d'
    done

    patchShebangs buildutils
  '';

  postInstall = ''
    cp -v buildutils/pbs_mkdirs $out/bin/
    cp -v torque.setup $out/bin/
    chmod +x $out/bin/pbs_mkdirs $out/bin/torque.setup
  '';

  meta = with lib; {
    homepage = "http://www.adaptivecomputing.com/products/open-source/torque";
    description = "Resource management system for submitting and controlling jobs on supercomputers, clusters, and grids";
    platforms = platforms.linux;
    license = "TORQUEv1.1";
  };
}
