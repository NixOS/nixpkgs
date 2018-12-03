{ stdenv, lib, fetchFromGitHub }:

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
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "i686-freebsd"
      "x86_64-freebsd"
    ] ++ lib.platforms.arm;
    maintainers = with lib.maintainers; [raskin];
    license = lib.licenses.mit;
    description = "Reparent a running program to a new terminal";
    homepage = https://github.com/nelhage/reptyr;
  };
}
