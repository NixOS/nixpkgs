{ stdenv, fetchFromGitHub, buildPackages, ncurses }:

let dialect = with stdenv.lib; last (splitString "-" stdenv.hostPlatform.system); in

stdenv.mkDerivation rec {
  pname = "lsof";
  version = "4.93.2";

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ ncurses ];

  src = fetchFromGitHub {
    owner = "lsof-org";
    repo = "lsof";
    rev = version;
    sha256 = "1gd6r0nv8xz76pmvk52dgmfl0xjvkxl0s51b4jk4a0lphw3393yv";
  };

  patches = [ ./no-build-info.patch ];

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
    cp Lsof.8 $out/man/man8/lsof.8
    cp lsof $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/lsof-org/lsof";
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
