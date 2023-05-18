{ stdenv, lib, buildPackages, fetchurl, fetchpatch, attr, runtimeShell
, usePam ? !isStatic, pam ? null
, isStatic ? stdenv.hostPlatform.isStatic
}:

assert usePam -> pam != null;

stdenv.mkDerivation rec {
  pname = "libcap";
  version = "2.66";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/security/linux-privs/libcap2/${pname}-${version}.tar.xz";
    sha256 = "sha256-FcQO3tswA9cKKD/lh6NrfRnIs7VU4z+GEpwFmku0ZrI=";
  };

  patches = [
    # https://www.x41-dsec.de/static/reports/X41-libcap-Code-Review-2023-OSTIF-Final-Report.pdf
    (fetchpatch {
      name = "CVE-2023-2602.patch";
      url = "https://git.kernel.org/pub/scm/libs/libcap/libcap.git/patch/?id=bc6b36682f188020ee4770fae1d41bde5b2c97bb";
      hash = "sha256-wV2rTzuwrPhl2Q9ytEB/VV2LXXz2urJC1YCDAm9LPcs=";
    })
    (fetchpatch {
      name = "CVE-2023-2603.patch";
      url = "https://git.kernel.org/pub/scm/libs/libcap/libcap.git/patch/?id=422bec25ae4a1ab03fd4d6f728695ed279173b18";
      hash = "sha256-3n5ubap+FtxNwmXc8I7+ceq2gz2sb9zoMTHeL5MP1zw=";
    })
  ];

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
