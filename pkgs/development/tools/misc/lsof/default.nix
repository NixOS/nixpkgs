{ lib, stdenv, fetchFromGitHub, fetchpatch, buildPackages, ncurses }:

let dialect = with lib; last (splitString "-" stdenv.hostPlatform.system); in

stdenv.mkDerivation rec {
  pname = "lsof";
  version = "4.95.0";

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ ncurses ];

  src = fetchFromGitHub {
    owner = "lsof-org";
    repo = "lsof";
    rev = version;
    sha256 = "sha256-HgU7/HxLdUOfLU2E/dpusko6gBOoEKeWPJIFbBQGzFU=";
  };

  patches = [
    ./no-build-info.patch

    # Pull upstream fix for -fno-common toolchains:
    #   https://github.com/lsof-org/lsof/pull/226
    #   https://github.com/lsof-org/lsof/pull/233
    (fetchpatch {
      name = "add-extern.patch";
      url = "https://github.com/lsof-org/lsof/commit/180ffa29b0544f77cabbc54d7f77d50d33dd27d7.patch";
      sha256 = "sha256-zzcN9HrFYMTBeEekeAwi2RIcVukymgaqtpvFIBV6njU=";
    })
    (fetchpatch {
      name = "add-declaration.patch";
      url = "https://github.com/lsof-org/lsof/commit/8e47e1491636e8cf41baf834554391be45177b00.patch";
      sha256 = "sha256-kwkDQp7VApLenOLTPMY24Me+/xUhD56skHWRd4ZB1I4=";
    })
  ];

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
