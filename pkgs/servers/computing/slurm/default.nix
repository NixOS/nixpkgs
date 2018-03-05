{ stdenv, fetchurl, pkgconfig, libtool, curl, python, munge, perl, pam, openssl
, ncurses, mysql, gtk2, lua, hwloc, numactl
}:

stdenv.mkDerivation rec {
  name = "slurm-${version}";
  version = "17.11.3";

  src = fetchurl {
    url = "https://download.schedmd.com/slurm/${name}.tar.bz2";
    sha256 = "1x3i6z03d9m46fvj1cslrapm1drvgyqch9pn4xf23kvbz4gkhaps";
  };

  outputs = [ "out" "dev" ];

  # nixos test fails to start slurmd with 'undefined symbol: slurm_job_preempt_mode'
  # https://groups.google.com/forum/#!topic/slurm-devel/QHOajQ84_Es
  # this doesn't fix tests completely at least makes slurmd to launch
  hardeningDisable = [ "bindnow" ];

  nativeBuildInputs = [ pkgconfig libtool ];
  buildInputs = [
    curl python munge perl pam openssl mysql.connector-c ncurses gtk2 lua hwloc numactl
  ];

  configureFlags =
    [ "--with-munge=${munge}"
      "--with-ssl=${openssl.dev}"
      "--sysconfdir=/etc/slurm"
    ] ++ stdenv.lib.optional (gtk2 == null)  "--disable-gtktest";

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
    maintainers = [ maintainers.jagajaga ];
  };
}
