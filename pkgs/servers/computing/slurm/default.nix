{ stdenv, fetchFromGitHub, pkgconfig, libtool, curl
, python3, munge, perl, pam, zlib, shadow, coreutils
, ncurses, libmysqlclient, gtk2, lua, hwloc, numactl
, readline, freeipmi, xorg, lz4, rdma-core, nixosTests
, pmix
# enable internal X11 support via libssh2
, enableX11 ? true
}:

stdenv.mkDerivation rec {
  pname = "slurm";
  version = "20.11.0.1";

  # N.B. We use github release tags instead of https://www.schedmd.com/downloads.php
  # because the latter does not keep older releases.
  src = fetchFromGitHub {
    owner = "SchedMD";
    repo = "slurm";
    # The release tags use - instead of .
    rev = "${pname}-${builtins.replaceStrings ["."] ["-"] version}";
    sha256 = "0f750wlvm48j5b2fkvhy47zyagxfl6kbn2m9lx0spxwyn9qgh6bn";
  };

  outputs = [ "out" "dev" ];

  patches = [
    # increase string length to allow for full
    # path of 'echo' in nix store
    ./common-env-echo.patch
    # Required for configure to pick up the right dlopen path
    ./pmix-configure.patch
  ];

  prePatch = ''
    substituteInPlace src/common/env.c \
        --replace "/bin/echo" "${coreutils}/bin/echo"
  '' + (stdenv.lib.optionalString enableX11 ''
    substituteInPlace src/common/x11_util.c \
        --replace '"/usr/bin/xauth"' '"${xorg.xauth}/bin/xauth"'
  '');

  # nixos test fails to start slurmd with 'undefined symbol: slurm_job_preempt_mode'
  # https://groups.google.com/forum/#!topic/slurm-devel/QHOajQ84_Es
  # this doesn't fix tests completely at least makes slurmd to launch
  hardeningDisable = [ "bindnow" ];

  nativeBuildInputs = [ pkgconfig libtool python3 ];
  buildInputs = [
    curl python3 munge perl pam zlib
      libmysqlclient ncurses gtk2 lz4 rdma-core
      lua hwloc numactl readline freeipmi shadow.su
      pmix
  ] ++ stdenv.lib.optionals enableX11 [ xorg.xauth ];

  configureFlags = with stdenv.lib;
    [ "--with-freeipmi=${freeipmi}"
      "--with-hwloc=${hwloc.dev}"
      "--with-lz4=${lz4.dev}"
      "--with-munge=${munge}"
      "--with-zlib=${zlib}"
      "--with-ofed=${rdma-core}"
      "--sysconfdir=/etc/slurm"
      "--with-pmix=${pmix}"
    ] ++ (optional (gtk2 == null)  "--disable-gtktest")
      ++ (optional (!enableX11) "--disable-x11");


  preConfigure = ''
    patchShebangs ./doc/html/shtml2html.py
    patchShebangs ./doc/man/man2html.py
  '';

  postInstall = ''
    rm -f $out/lib/*.la $out/lib/slurm/*.la
  '';

  enableParallelBuilding = true;

  passthru.tests.slurm = nixosTests.slurm;

  meta = with stdenv.lib; {
    homepage = "http://www.schedmd.com/";
    description = "Simple Linux Utility for Resource Management";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jagajaga markuskowa ];
  };
}
