{ stdenv, fetchurl, buildPackages, ncurses }:

let dialect = with stdenv.lib; last (splitString "-" stdenv.hostPlatform.system); in

stdenv.mkDerivation rec {
  name = "lsof-${version}";
  version = "4.91";

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ ncurses ];

  src = fetchurl {
    urls = ["https://fossies.org/linux/misc/lsof_${version}.tar.bz2"] ++ # Mirrors seem to be down...
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
    sha256 = "18sh4hbl9jw2szkf0gvgan8g13f3g4c6s2q9h3zq5gsza9m99nn9";
  };

  unpackPhase = "tar xvjf $src; cd lsof_*; tar xvf lsof_*.tar; sourceRoot=$( echo lsof_*/); ";

  patches = [ ./no-build-info.patch ] ++ stdenv.lib.optional stdenv.isDarwin ./darwin-dfile.patch;

  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace dialects/linux/dlsof.h --replace "defined(__UCLIBC__)" 1
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's|lcurses|lncurses|g' Configure
  '';

  # Stop build scripts from searching global include paths
  LSOF_INCLUDE = "${stdenv.lib.getDev stdenv.cc.libc}/include";
  configurePhase = "LINUX_CONF_CC=$CC_FOR_BUILD LSOF_CC=$CC LSOF_AR=\"$AR cr\" LSOF_RANLIB=$RANLIB ./Configure -n ${dialect}";
  preBuild = ''
    for filepath in $(find dialects/${dialect} -type f); do
      sed -i "s,/usr/include,$LSOF_INCLUDE,g" $filepath
    done
  '';

  installPhase = ''
    mkdir -p $out/bin $out/man/man8
    cp lsof.8 $out/man/man8/
    cp lsof $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://people.freebsd.org/~abe/;
    description = "A tool to list open files";
    longDescription = ''
      List open files. Can show what process has opened some file,
      socket (IPv6/IPv4/UNIX local), or partition (by opening a file
      from it).
    '';
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
    license = licenses.purdueBsd;
  };
}
