{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ucspi-tcp-0.88";

  src = fetchurl {
    url = "http://cr.yp.to/ucspi-tcp/${name}.tar.gz";
    sha256 = "171yl9kfm8w7l17dfxild99mbf877a9k5zg8yysgb1j8nz51a1ja";
  };

  # Plain upstream tarball doesn't build, get patches from Debian
  patches = [
    (fetchurl {
      url = "http://ftp.de.debian.org/debian/pool/main/u/ucspi-tcp/ucspi-tcp_0.88-3.diff.gz";
      sha256 = "0mzmhz8hjkrs0khmkzs5i0s1kgmgaqz07h493bd5jj5fm5njxln6";
    })
  ];

  # Apply Debian patches
  postPatch = ''
    for fname in debian/diff/*.diff; do
        echo "Applying patch $fname"
        patch < "$fname"
    done
  '';

  # The build system is weird; 'make install' doesn't install anything, instead
  # it builds an executable called ./install (from C code) which installs
  # binaries to the directory given on line 1 in ./conf-home.
  #
  # Also, assume getgroups and setgroups work, instead of doing a build time
  # test that breaks on NixOS (I think because nixbld users lack CAP_SETGID
  # capability).
  preBuild = ''
    echo "$out" > conf-home

    echo "main() { return 0; }" > chkshsgr.c
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/man/man1"

    # run the newly built installer
    ./install

    # Install Debian man pages (upstream has none)
    cp debian/ucspi-tcp-man/*.1 "$out/share/man/man1"
  '';

  meta = with stdenv.lib; {
    description = "Command-line tools for building TCP client-server applications";
    longDescription = ''
      tcpserver waits for incoming connections and, for each connection, runs a
      program of your choice. Your program receives environment variables
      showing the local and remote host names, IP addresses, and port numbers.

      tcpserver offers a concurrency limit to protect you from running out of
      processes and memory. When you are handling 40 (by default) simultaneous
      connections, tcpserver smoothly defers acceptance of new connections.

      tcpserver also provides TCP access control features, similar to
      tcp-wrappers/tcpd's hosts.allow but much faster. Its access control rules
      are compiled into a hashed format with cdb, so it can easily deal with
      thousands of different hosts.

      This package includes a recordio tool that monitors all the input and
      output of a server.

      tcpclient makes a TCP connection and runs a program of your choice. It
      sets up the same environment variables as tcpserver.

      This package includes several sample clients built on top of tcpclient:
      who@, date@, finger@, http@, tcpcat, and mconnect.

      tcpserver and tcpclient conform to UCSPI, the UNIX Client-Server Program
      Interface, using the TCP protocol. UCSPI tools are available for several
      different networks.
    '';
    homepage = http://cr.yp.to/ucspi-tcp.html;
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
