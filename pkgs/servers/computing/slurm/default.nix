{ stdenv, fetchFromGitHub, pkgconfig, libtool, curl
, python, munge, perl, pam, openssl
, ncurses, mysql, gtk2, lua, hwloc, numactl
, readline, freeipmi, libssh2, xorg
# enable internal X11 support via libssh2
, enableX11 ? true
}:

stdenv.mkDerivation rec {
  name = "slurm-${version}";
  version = "18.08.0-1";

  # N.B. We use github release tags instead of https://www.schedmd.com/downloads.php
  # because the latter does not keep older releases.
  src = fetchFromGitHub {
    owner = "SchedMD";
    repo = "slurm";
    # The release tags use - instead of .
    rev = "${builtins.replaceStrings ["."] ["-"] name}";
    sha256 = "0mnaynnpz0cyd1lspcln6h6w5d7brcw3yiqsfxqrfhlmygyp21wq";
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
    curl python munge perl pam openssl
      mysql.connector-c ncurses gtk2
      lua hwloc numactl readline freeipmi
  ] ++ stdenv.lib.optionals enableX11 [ libssh2 xorg.xauth ];

  configureFlags = with stdenv.lib;
    [ "--with-munge=${munge}"
      "--with-ssl=${openssl.dev}"
      "--with-hwloc=${hwloc.dev}"
      "--with-freeipmi=${freeipmi}"
      "--sysconfdir=/etc/slurm"
    ] ++ (optional (gtk2 == null)  "--disable-gtktest")
      ++ (optional enableX11 "--with-libssh2=${libssh2.dev}");


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
