{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  perl,
  readline,
  rsh,
  ssh,
  slurm,
  slurmSupport ? false,
}:

stdenv.mkDerivation rec {
  pname = "pdsh";
  version = "2.35";

  src = fetchurl {
    url = "https://github.com/chaos/pdsh/releases/download/pdsh-${version}/pdsh-${version}.tar.gz";
    sha256 = "sha256-de8VNHhI//Q/jW/5xEJP4Fx90s26ApE5kB+GGgUJPP4=";
  };

  buildInputs = [
    perl
    readline
    ssh
  ] ++ (lib.optional slurmSupport slurm);

  nativeBuildInputs = [ autoreconfHook ];

  # Do not use git to derive a version.
  postPatch = ''
    sed -i 's/m4_esyscmd(\[git describe.*/[${version}])/' configure.ac
  '';

  preConfigure = ''
    configureFlagsArray=(
      "--infodir=$out/share/info"
      "--mandir=$out/share/man"
      "--with-machines=/etc/pdsh/machines"
      ${if readline == null then "--without-readline" else "--with-readline"}
      ${if ssh == null then "--without-ssh" else "--with-ssh"}
      ${if rsh == false then "--without-rsh" else "--with-rsh"}
      ${if slurmSupport then "--with-slurm" else "--without-slurm"}
      "--with-dshgroups"
      "--with-xcpu"
      "--disable-debug"
      '--with-rcmd-rank-list=ssh,krb4,exec,xcpu,rsh'
    )
  '';

  meta = {
    homepage = "https://github.com/chaos/pdsh";
    description = "High-performance, parallel remote shell utility";
    license = lib.licenses.gpl2Plus;

    longDescription = ''
      Pdsh is a high-performance, parallel remote shell utility. It has
      built-in, thread-safe clients for Berkeley and Kerberos V4 rsh and
      can call SSH externally (though with reduced performance). Pdsh
      uses a "sliding window" parallel algorithm to conserve socket
      resources on the initiating node and to allow progress to continue
      while timeouts occur on some connections.
    '';

    platforms = lib.platforms.unix;
  };
}
