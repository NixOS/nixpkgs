{ stdenv, fetchurl, pkgconfig, libtool, curl, python, munge, perl, pam, openssl
, ncurses, mysql, gtk2, lua, hwloc, numactl
}:

stdenv.mkDerivation rec {
  name = "slurm-${version}";
  version = "17.02.6";

  src = fetchurl {
    url = "https://www.schedmd.com/downloads/latest/slurm-17.02.6.tar.bz2";
    sha256 = "1sp4xg15jc569r6dh61svgk2fmy3ndcgr5358yryajslf1w14mzh";
  };

  outputs = [ "out" "dev" ];

  # nixos test fails to start slurmd with 'undefined symbol: slurm_job_preempt_mode'
  # https://groups.google.com/forum/#!topic/slurm-devel/QHOajQ84_Es
  # this doesn't fix tests completely at least makes slurmd to launch
  hardeningDisable = [ "bindnow" ];

  nativeBuildInputs = [ pkgconfig libtool ];
  buildInputs = [
    curl python munge perl pam openssl mysql.lib ncurses gtk2 lua hwloc numactl
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

  meta = with stdenv.lib; {
    homepage = http://www.schedmd.com/;
    description = "Simple Linux Utility for Resource Management";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.jagajaga ];
  };
}
