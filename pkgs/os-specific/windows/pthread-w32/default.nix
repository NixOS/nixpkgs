{ fetchurl, stdenv, mingw_headers }:

# This file is tweaked for cross-compilation only.
assert stdenv ? cross;

stdenv.mkDerivation {
  name = "pthread-w32-1.10.0";

  src = fetchurl {
    url = "ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-1-10-0-release.tar.gz";
    sha256 = "1vllxxfa9a7mssb1x98a2r736vsv5ll3sjizbr7a8hw8j9p18j7n";
  };

  configurePhase =
    '' sed -i GNUmakefile \
           -e 's/CC=gcc/CC=i686-pc-mingw32-gcc/g ;
               s/windres/i686-pc-mingw32-windres/g ;
               s/dlltool/i686-pc-mingw32-dlltool/g'
    '';

  buildInputs = [ mingw_headers ];

  buildPhase = "make GC";        # to build the GNU C dll with C cleanup code

  installPhase =
    '' mkdir -p "$out" "$out/include" "$out/lib"
       cp -v *pthread*{dll,a} "$out/lib"
       cp -v pthread.h semaphore.h sched.h "$out/include"
    '';

  meta = {
    description = "POSIX threads for Woe32";

    longDescription =
      '' The POSIX 1003.1-2001 standard defines an application programming
         interface (API) for writing multithreaded applications.  This
         interface is known more commonly as pthreads.  A good number of
         modern operating systems include a threading library of some kind:
         Solaris (UI) threads, Win32 threads, DCE threads, DECthreads, or any
         of the draft revisions of the pthreads standard.  The trend is that
         most of these systems are slowly adopting the pthreads standard API,
         with application developers following suit to reduce porting woes.

         Woe32 does not, and is unlikely to ever, support pthreads natively.
         This project seeks to provide a freely available and high-quality
         solution to this problem.
      '';

    homepage = http://sourceware.org/pthreads-win32/;

    license = "LGPLv2.1+";
  };
}
