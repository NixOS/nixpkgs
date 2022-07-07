{ lib, stdenv, fetchFromGitHub, automake, autoconf, libtool, flex, bison, texinfo, fetchpatch, pkgsStatic
, withNcurses ? true, ncurses
}:

stdenv.mkDerivation rec {
  pname = "gpm";
  version = "unstable-2020-06-17";

  src = fetchFromGitHub {
    owner = "telmich";
    repo = "gpm";
    rev = "e82d1a653ca94aa4ed12441424da6ce780b1e530";
    sha256 = "0ndn6dwc87slvyqp2cnbb02a6hkjwb6zjhs6viysykv06hq7ihy6";
  };

  postPatch = ''
    substituteInPlace src/prog/gpm-root.y --replace __sigemptyset sigemptyset
  '';

  nativeBuildInputs = [ automake autoconf libtool flex bison texinfo ];
  buildInputs = [ ncurses ];

  hardeningDisable = [ "format" ];

  patches = [
    (fetchpatch { # pull request telmich/gpm#42
      url = "https://github.com/kaction/gpm/commit/217b4fe4c9b62298a4e9a54c1f07e3b52b013a09.patch";
      sha256 = "1f74h12iph4z1dldbxk9imcq11805c3ai2xhbsqvx8jpjrcfp19q";
    })

    # Pull fix pending upstream inclusion to fix parallel installation:
    #   https://github.com/telmich/gpm/pull/43
    (fetchpatch {
      name = "parallel-install.patch";
      url = "https://github.com/telmich/gpm/commit/a88fb82a7afe96e872bb31c554e9ad5888f5a451.patch";
      sha256 = "0g1jhz9bjw7vqjv922xkhs8xkjxdqh11nj38jj3c8nv5lcil76nx";
    })
  ];
  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (if ncurses == null then "--without-curses" else "--with-curses")
  ];

  enableParallelBuilding = true;

  # Provide libgpm.so for compatability
  postInstall = ''
    ln -sv $out/lib/libgpm.so.2 $out/lib/libgpm.so
  '';

  passthru.tests.static = pkgsStatic.gpm;

  meta = with lib; {
    homepage = "https://www.nico.schottelius.org/software/gpm/";
    description = "A daemon that provides mouse support on the Linux console";
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.cygwin;
    maintainers = with maintainers; [ eelco ];
  };
}
