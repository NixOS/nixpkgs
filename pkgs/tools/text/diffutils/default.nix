{ stdenv, fetchurl, xz, coreutils ? null }:

stdenv.mkDerivation rec {
  name = "diffutils-3.7";

  src = fetchurl {
    url = "mirror://gnu/diffutils/${name}.tar.xz";
    sha256 = "09isrg0isjinv8c535nxsi1s86wfdfzml80dbw41dj9x3hiad9xk";
  };

  outputs = [ "out" "info" ];

  nativeBuildInputs = [ xz.bin ];
  /* If no explicit coreutils is given, use the one from stdenv. */
  buildInputs = [ coreutils ];

  configureFlags =
    # "pr" need not be on the PATH as a run-time dep, so we need to tell
    # configure where it is. Covers the cross and native case alike.
    stdenv.lib.optional (coreutils != null) "PR_PROGRAM=${coreutils}/bin/pr"
    ++ stdenv.lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "gl_cv_func_getopt_gnu=yes";

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/diffutils/diffutils.html;
    description = "Commands for showing the differences between files (diff, cmp, etc.)";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
