{ stdenv, fetchurl, attr, perl, pam ? null }:
assert pam != null -> stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libcap-${version}";
  version = "2.25";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/security/linux-privs/libcap2/${name}.tar.xz";
    sha256 = "0qjiqc5pknaal57453nxcbz3mn1r4hkyywam41wfcglq3v2qlg39";
  };

  outputs = [ "dev" "lib" "doc" "out" ]
    ++ stdenv.lib.optional (pam != null) "pam";

  nativeBuildInputs = [ perl ];

  buildInputs = [ pam ];

  propagatedBuildInputs = [ attr ];

  makeFlags = [
    "lib=lib"
    (stdenv.lib.optional (pam != null) "PAM_CAP=yes")
  ];

  prePatch = ''
    # use relative bash path
    substituteInPlace progs/capsh.c --replace "/bin/bash" "bash"

    # ensure capsh can find bash in $PATH
    substituteInPlace progs/capsh.c --replace execve execvpe
  '';

  preInstall = ''
    substituteInPlace Make.Rules \
      --replace 'prefix=/usr' "prefix=$lib" \
      --replace 'exec_prefix=' "exec_prefix=$out" \
      --replace 'lib_prefix=$(exec_prefix)' "lib_prefix=$lib" \
      --replace 'inc_prefix=$(prefix)' "inc_prefix=$dev" \
      --replace 'man_prefix=$(prefix)' "man_prefix=$doc"
  '';

  installFlags = "RAISE_SETFCAP=no";

  postInstall = ''
    rm "$lib"/lib/*.a
    mkdir -p "$doc/share/doc/${name}"
    cp License "$doc/share/doc/${name}/"
  '' + stdenv.lib.optionalString (pam != null) ''
    mkdir -p "$pam/lib/security"
    mv "$lib"/lib/security "$pam/lib"
  '';

  meta = {
    description = "Library for working with POSIX capabilities";
    platforms = stdenv.lib.platforms.linux;
  };
}
