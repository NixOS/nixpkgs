{ lib, stdenv, fetchFromGitHub, buildPackages, ncurses }:

let dialect = with lib; last (splitString "-" stdenv.hostPlatform.system); in

stdenv.mkDerivation rec {
  pname = "lsof";
  version = "4.94.0";

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ ncurses ];

  src = fetchFromGitHub {
    owner = "lsof-org";
    repo = "lsof";
    rev = version;
    sha256 = "0yxv2jg6rnzys49lyrz9yjb4knamah4xvlqj596y6ix3vm4k3chp";
  };

  patches = [ ./no-build-info.patch ];

  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace dialects/linux/dlsof.h --replace "defined(__UCLIBC__)" 1
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i 's|lcurses|lncurses|g' Configure
  '';

  # Stop build scripts from searching global include paths
  LSOF_INCLUDE = "${lib.getDev stdenv.cc.libc}/include";
  configurePhase = "LINUX_CONF_CC=$CC_FOR_BUILD LSOF_CC=$CC LSOF_AR=\"$AR cr\" LSOF_RANLIB=$RANLIB ./Configure -n ${dialect}";
  preBuild = ''
    for filepath in $(find dialects/${dialect} -type f); do
      sed -i "s,/usr/include,$LSOF_INCLUDE,g" $filepath
    done
  '';

  installPhase = ''
    # Fix references from man page https://github.com/lsof-org/lsof/issues/66
    substituteInPlace Lsof.8 \
      --replace ".so ./00DIALECTS" "" \
      --replace ".so ./version" ".ds VN ${version}"
    mkdir -p $out/bin $out/man/man8
    cp Lsof.8 $out/man/man8/lsof.8
    cp lsof $out/bin
  '';

  meta = with lib; {
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
