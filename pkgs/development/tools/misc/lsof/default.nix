{ lib, stdenv, fetchFromGitHub, buildPackages, perl, which, ncurses, nukeReferences }:

let
  dialect = lib.last (lib.splitString "-" stdenv.hostPlatform.system);
in

stdenv.mkDerivation rec {
  pname = "lsof";
  version = "4.99.3";

  src = fetchFromGitHub {
    owner = "lsof-org";
    repo = "lsof";
    rev = version;
    hash = "sha256-XW3l+E9D8hgI9jGJGKkIAKa8O9m0JHgZhEASqg4gYuw=";
  };

  postPatch = ''
    patchShebangs --build lib/dialects/*/Mksrc
    # Do not re-build version.h in every 'make' to allow nuke-refs below.
    # We remove phony 'FRC' target that forces rebuilds:
    #   'version.h: FRC ...' is translated to 'version.h: ...'.
    sed -i lib/dialects/*/Makefile -e 's/version.h:\s*FRC/version.h:/'
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i 's|lcurses|lncurses|g' Configure
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ nukeReferences perl which ];
  buildInputs = [ ncurses ];

  # Stop build scripts from searching global include paths
  LSOF_INCLUDE = "${lib.getDev stdenv.cc.libc}/include";
  configurePhase = "LINUX_CONF_CC=$CC_FOR_BUILD LSOF_CC=$CC LSOF_AR=\"$AR cr\" LSOF_RANLIB=$RANLIB ./Configure -n ${dialect}";

  preBuild = ''
    for filepath in $(find dialects/${dialect} -type f); do
      sed -i "s,/usr/include,$LSOF_INCLUDE,g" $filepath
    done

    # Wipe out development-only flags from CFLAGS embedding
    make version.h
    nuke-refs version.h
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

  meta = {
    homepage = "https://github.com/lsof-org/lsof";
    description = "Tool to list open files";
    mainProgram = "lsof";
    longDescription = ''
      List open files. Can show what process has opened some file,
      socket (IPv6/IPv4/UNIX local), or partition (by opening a file
      from it).
    '';
    license = lib.licenses.purdueBsd;
    maintainers = with lib.maintainers; [ dezgeg ];
    platforms = lib.platforms.unix;
  };
}
