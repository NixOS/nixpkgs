{ stdenv, lib, buildPackages, fetchurl, attr, runtimeShell
, usePam ? !isStatic, pam ? null
, isStatic ? stdenv.hostPlatform.isStatic
}:

assert usePam -> pam != null;

stdenv.mkDerivation rec {
  pname = "libcap";
  version = "2.65";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/security/linux-privs/libcap2/${pname}-${version}.tar.xz";
    sha256 = "sha256-c+NQAgzDH+FTYIedGThP+jOVqCXwZfz2vaOlzfllvr0=";
  };

  outputs = [ "out" "dev" "lib" "man" "doc" ]
    ++ lib.optional usePam "pam";

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = lib.optional usePam pam;

  propagatedBuildInputs = [ attr ];

  makeFlags = [
    "lib=lib"
    "PAM_CAP=${if usePam then "yes" else "no"}"
    "BUILD_CC=$(CC_FOR_BUILD)"
    "CC:=$(CC)"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ] ++ lib.optional isStatic "SHARED=no";

  postPatch = ''
    patchShebangs ./progs/mkcapshdoc.sh

    # use full path to bash
    substituteInPlace progs/capsh.c --replace "/bin/bash" "${runtimeShell}"

    # set prefixes
    substituteInPlace Make.Rules \
      --replace 'prefix=/usr' "prefix=$lib" \
      --replace 'exec_prefix=' "exec_prefix=$out" \
      --replace 'lib_prefix=$(exec_prefix)' "lib_prefix=$lib" \
      --replace 'inc_prefix=$(prefix)' "inc_prefix=$dev" \
      --replace 'man_prefix=$(prefix)' "man_prefix=$doc"
  '';

  installFlags = [ "RAISE_SETFCAP=no" ];

  postInstall = ''
    ${lib.optionalString (!isStatic) ''rm "$lib"/lib/*.a''}
    mkdir -p "$doc/share/doc/${pname}-${version}"
    cp License "$doc/share/doc/${pname}-${version}/"
  '' + lib.optionalString usePam ''
    mkdir -p "$pam/lib/security"
    mv "$lib"/lib/security "$pam/lib"
  '';

  meta = {
    description = "Library for working with POSIX capabilities";
    homepage = "https://sites.google.com/site/fullycapable";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
  };
}
