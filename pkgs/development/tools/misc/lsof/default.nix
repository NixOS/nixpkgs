{ stdenv, fetchurl, buildPackages, ncurses }:

let dialect = with stdenv.lib; last (splitString "-" stdenv.system); in

stdenv.mkDerivation rec {
  name = "lsof-${version}";
  version = "4.89";

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ ncurses ];

  src = fetchurl {
    urls =
      ["ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_${version}.tar.bz2"]
      ++ map (
        # the tarball is moved after new version is released
        isOld: "ftp://sunsite.ualberta.ca/pub/Mirror/lsof/"
        + "${stdenv.lib.optionalString isOld "OLD/"}lsof_${version}.tar.bz2"
      ) [ false true ]
      ++ map (
        # the tarball is moved after new version is released
        isOld: "http://www.mirrorservice.org/sites/lsof.itap.purdue.edu/pub/tools/unix/lsof/"
        + "${stdenv.lib.optionalString isOld "OLD/"}lsof_${version}.tar.bz2"
      ) [ false true ]
      ;
    sha256 = "061p18v0mhzq517791xkjs8a5dfynq1418a1mwxpji69zp2jzb41";
  };

  unpackPhase = "tar xvjf $src; cd lsof_*; tar xvf lsof_*.tar; sourceRoot=$( echo lsof_*/); ";

  patches = [ ./dfile.patch ];

  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace dialects/linux/dlsof.h --replace "defined(__UCLIBC__)" 1
  '';

  # Stop build scripts from searching global include paths
  LSOF_INCLUDE = "${stdenv.cc.libc}/include";
  configurePhase = "LINUX_CONF_CC=$CC_FOR_BUILD LSOF_CC=$CC LSOF_AR=\"$AR cr\" LSOF_RANLIB=$RANLIB ./Configure -n ${dialect}";
  preBuild = ''
    sed -i Makefile -e 's/^CFGF=/&	-DHASIPv6=1/;' -e 's/-lcurses/-lncurses/'
    for filepath in $(find dialects/${dialect} -type f); do
      sed -i "s,/usr/include,$LSOF_INCLUDE,g" $filepath
    done
  '';

  installPhase = ''
    mkdir -p $out/bin $out/man/man8
    cp lsof.8 $out/man/man8/
    cp lsof $out/bin
  '';

  meta = {
    homepage = ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/;
    description = "A tool to list open files";
    longDescription = ''
      List open files. Can show what process has opened some file,
      socket (IPv6/IPv4/UNIX local), or partition (by opening a file
      from it).
    '';
    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
