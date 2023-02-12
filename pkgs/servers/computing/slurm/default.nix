{ lib, stdenv, fetchFromGitHub, pkg-config, libtool, curl
, python3, munge, perl, pam, shadow, coreutils, dbus, libbpf
, ncurses, libmysqlclient, lua, hwloc, numactl
, readline, freeipmi, xorg, lz4, rdma-core, nixosTests
, pmix
, libjwt
, libyaml
, json_c
, http-parser
# enable internal X11 support via libssh2
, enableX11 ? true
, enableGtk2 ? false, gtk2
}:

stdenv.mkDerivation rec {
  pname = "slurm";
  version = "22.05.8.1";

  # N.B. We use github release tags instead of https://www.schedmd.com/downloads.php
  # because the latter does not keep older releases.
  src = fetchFromGitHub {
    owner = "SchedMD";
    repo = "slurm";
    # The release tags use - instead of .
    rev = "${pname}-${builtins.replaceStrings ["."] ["-"] version}";
    sha256 = "sha256-hL/FnHl+Fj62xGH1FVkB9jVtvrVxbPU73DlMWC6CyJ0=";
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
  '' + (lib.optionalString enableX11 ''
    substituteInPlace src/common/x11_util.c \
        --replace '"/usr/bin/xauth"' '"${xorg.xauth}/bin/xauth"'
  '');

  # nixos test fails to start slurmd with 'undefined symbol: slurm_job_preempt_mode'
  # https://groups.google.com/forum/#!topic/slurm-devel/QHOajQ84_Es
  # this doesn't fix tests completely at least makes slurmd to launch
  hardeningDisable = [ "bindnow" ];

  nativeBuildInputs = [ pkg-config libtool python3 perl ];
  buildInputs = [
    curl python3 munge pam
    libmysqlclient ncurses lz4 rdma-core
    lua hwloc numactl readline freeipmi shadow.su
    pmix json_c libjwt libyaml dbus libbpf
    http-parser
  ] ++ lib.optionals enableX11 [ xorg.xauth ]
  ++ lib.optionals enableGtk2 [ gtk2 ];

  configureFlags = with lib;
    [ "--with-freeipmi=${freeipmi}"
      "--with-http-parser=${http-parser}"
      "--with-hwloc=${hwloc.dev}"
      "--with-json=${json_c.dev}"
      "--with-jwt=${libjwt}"
      "--with-lz4=${lz4.dev}"
      "--with-munge=${munge}"
      "--with-yaml=${libyaml}"
      "--with-ofed=${rdma-core}"
      "--sysconfdir=/etc/slurm"
      "--with-pmix=${pmix}"
      "--with-bpf=${libbpf}"
    ] ++ (optional enableGtk2  "--disable-gtktest")
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

  meta = with lib; {
    homepage = "http://www.schedmd.com/";
    description = "Simple Linux Utility for Resource Management";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jagajaga markuskowa ];
  };
}
