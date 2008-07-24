{stdenv, fetchurl, ncurses ? null}:

stdenv.mkDerivation {
  name = "util-linux-2.13-pre7";

  src = fetchurl {
    url = mirror://kernel/linux/utils/util-linux/testing/util-linux-2.13-pre7.tar.bz2;
    md5 = "13cdf4b76533e8421dc49de188f85291";
  };

  patches = [
    # Fix for a local root exploit via mount/umount
    # (http://www.gentoo.org/security/en/glsa/glsa-200710-18.xml).
    (fetchurl {
      url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/sys-apps/util-linux/files/util-linux-2.13-setuid-checks.patch?rev=1.1";
      sha256 = "02ky7ljzqpx8ii3dfmjydw8nnhshpw2inwh6w1vqllz8mhn81jdf";
    })
  ];

  configureFlags = "--disable-use-tty-group";

  buildInputs = stdenv.lib.optional (ncurses != null) ncurses;

  preBuild = ''
    makeFlagsArray=(usrbinexecdir=$out/bin usrsbinexecdir=$out/sbin datadir=$out/share exampledir=$out/share/getopt)
  '';

  # Hack to get static builds to work.
  NIX_CFLAGS_COMPILE = "-DHAVE___PROGNAME=1"; 
}
