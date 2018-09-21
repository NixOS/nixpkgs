{stdenv, fetchFromGitHub, libelf, libdwarf, ncurses }:

stdenv.mkDerivation rec {
  name = "uftrace-${version}";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "namhyung";
    repo = "uftrace";
    rev = "f0fed0b24a9727ffed04673b62f66baad21a1f99";
    sha256 = "0rn2xwd87qy5ihn5zq9pwq8cs1vfmcqqz0wl70wskkgp2ccsd9x8";
  };

  meta = {
    description = "Function (graph) tracer for user-space";
    homepage = https://github.com/namhyung/uftrace;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.nthorne];
  };
}

