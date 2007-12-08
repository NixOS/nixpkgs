args: with args;

stdenv.mkDerivation {
  name = "util-linux-2.13-pre7";

  src = fetchurl {
    url = mirror://kernel/linux/utils/util-linux/testing/util-linux-2.13-pre7.tar.bz2;
    md5 = "13cdf4b76533e8421dc49de188f85291";
  };
  
  configureFlags = "--disable-use-tty-group";

  buildInputs = [] 
  	++ (if args ? ncurses then [args.ncurses] else [])
  ;

  preBuild = "
    makeFlagsArray=(usrbinexecdir=$out/bin usrsbinexecdir=$out/sbin datadir=$out/share exampledir=$out/share/getopt)
  ";

  # Hack to get static builds to work.
  NIX_CFLAGS_COMPILE = "-DHAVE___PROGNAME=1"; 
}
