{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.6.2";
  name = "reptyr-${version}";
  src = fetchFromGitHub {
    owner = "nelhage";
    repo = "reptyr";
    rev = "reptyr-${version}";
    sha256 = "0yfy1p0mz05xg5gzp52vilfz0yl1sjjsvwn0z073mnr4wyam7fg8";
  };

  # Avoid a glibc >= 2.25 deprecation warning that gets fatal via -Werror.
  postPatch = ''
    sed 1i'#include <sys/sysmacros.h>' -i platform/linux/linux.c
  '';

  # Needed with GCC 7
  NIX_CFLAGS_COMPILE = "-Wno-error=format-truncation";

  makeFlags = ["PREFIX=$(out)"];
  meta = {
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.mit;
    description = ''A Linux tool to change controlling pty of a process'';
  };
}
