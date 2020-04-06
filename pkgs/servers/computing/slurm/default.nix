{ stdenv, fetchFromGitHub, pkgconfig, libtool, curl
, python, munge, perl, pam, openssl, zlib
, ncurses, libmysqlclient, gtk2, lua, hwloc, numactl
, readline, freeipmi, libssh2, xorg, lz4, rdma-core
# enable internal X11 support via libssh2
, enableX11 ? true
}:

stdenv.mkDerivation rec {
  pname = "slurm";
  version = "19.05.5.1";

  # N.B. We use github release tags instead of https://www.schedmd.com/downloads.php
  # because the latter does not keep older releases.
  src = fetchFromGitHub {
    owner = "SchedMD";
    repo = "slurm";
    # The release tags use - instead of .
    rev = "${pname}-${builtins.replaceStrings ["."] ["-"] version}";
    sha256 = "0f0gv3sirp6sxdrbwydsbcqicjbmrpm58yhgbsar8v6nx3g6y3hx";
  };

  outputs = [ "out" "dev" ];

  prePatch = stdenv.lib.optional enableX11 ''
    substituteInPlace src/common/x11_util.c \
        --replace '"/usr/bin/xauth"' '"${xorg.xauth}/bin/xauth"'
  '';

  # nixos test fails to start slurmd with 'undefined symbol: slurm_job_preempt_mode'
  # https://groups.google.com/forum/#!topic/slurm-devel/QHOajQ84_Es
  # this doesn't fix tests completely at least makes slurmd to launch
  hardeningDisable = [ "bindnow" ];

  nativeBuildInputs = [ pkgconfig libtool ];
  buildInputs = [
    curl python munge perl pam openssl zlib
      libmysqlclient ncurses gtk2 lz4 rdma-core
      lua hwloc numactl readline freeipmi
  ] ++ stdenv.lib.optionals enableX11 [ libssh2 xorg.xauth ];

  configureFlags = with stdenv.lib;
    [ "--with-freeipmi=${freeipmi}"
      "--with-hwloc=${hwloc.dev}"
      "--with-lz4=${lz4.dev}"
      "--with-munge=${munge}"
      "--with-ssl=${openssl.dev}"
      "--with-zlib=${zlib}"
      "--with-ofed=${rdma-core}"
      "--sysconfdir=/etc/slurm"
    ] ++ (optional (gtk2 == null)  "--disable-gtktest")
      ++ (optional enableX11 "--with-libssh2=${libssh2.dev}")
      ++ (optional (!enableX11) "--disable-x11");


  preConfigure = ''
    patchShebangs ./doc/html/shtml2html.py
    patchShebangs ./doc/man/man2html.py
  '';

  postInstall = ''
    rm -f $out/lib/*.la $out/lib/slurm/*.la
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.schedmd.com/;
    description = "Simple Linux Utility for Resource Management";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jagajaga markuskowa ];
  };
}
