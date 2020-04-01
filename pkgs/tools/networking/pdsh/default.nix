{ stdenv, fetchurl, perl, readline, rsh, ssh }:

stdenv.mkDerivation rec {
  name = "pdsh-2.34";

  src = fetchurl {
    url = "https://github.com/chaos/pdsh/releases/download/${name}/${name}.tar.gz";
    sha256 = "1s91hmhrz7rfb6h3l5k97s393rcm1ww3svp8dx5z8vkkc933wyxl";
  };

  buildInputs = [ perl readline ssh ];

  preConfigure = ''
    configureFlagsArray=(
      "--infodir=$out/share/info"
      "--mandir=$out/share/man"
      "--with-machines=/etc/pdsh/machines"
      ${if readline == null then "--without-readline" else "--with-readline"}
      ${if ssh == null then "--without-ssh" else "--with-ssh"}
      ${if rsh == false then "--without-rsh" else "--with-rsh"}
      "--with-dshgroups"
      "--with-xcpu"
      "--disable-debug"
      '--with-rcmd-rank-list=ssh,krb4,exec,xcpu,rsh'
    )
  '';

  meta = {
    homepage = https://github.com/chaos/pdsh;
    description = "High-performance, parallel remote shell utility";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Pdsh is a high-performance, parallel remote shell utility. It has
      built-in, thread-safe clients for Berkeley and Kerberos V4 rsh and
      can call SSH externally (though with reduced performance). Pdsh
      uses a "sliding window" parallel algorithm to conserve socket
      resources on the initiating node and to allow progress to continue
      while timeouts occur on some connections.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
