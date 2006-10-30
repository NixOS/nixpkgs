{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "util-linux-2.13-pre7";

  src = fetchurl {
    url = ftp://ftp.nl.kernel.org/pub/linux/utils/util-linux/testing/util-linux-2.13-pre7.tar.bz2;
    md5 = "13cdf4b76533e8421dc49de188f85291";
  };
  
  configureFlags = "--disable-use-tty-group";

  preBuild = "
    makeFlagsArray=(usrbinexecdir=$out/bin usrsbinexecdir=$out/sbin datadir=$out/share exampledir=$out/share/getopt)
    installFlagsArray=(\"\${makeFlagsArray[@]}\")
  ";
}
