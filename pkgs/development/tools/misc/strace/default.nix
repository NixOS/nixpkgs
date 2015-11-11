{ stdenv, fetchurl, perl, stacktraceSupport ? true, libunwind }:

let optional = stdenv.lib.optional;
    optionalString = stdenv.lib.optionalString;
in

assert stacktraceSupport -> libunwind != null;

stdenv.mkDerivation rec {
  name = "strace-4.10";

  src = fetchurl {
    url = "mirror://sourceforge/strace/${name}.tar.xz";
    sha256 = "1qhfwijxvblwdvvm70f8bhzs4fpbzqmwwbkfp636brzrds30s676";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = optional stacktraceSupport libunwind;

  configureFlags = ''
    ${optionalString stacktraceSupport "--with-libunwind"}
  '';

  meta = with stdenv.lib; {
    homepage = http://strace.sourceforge.net/;
    description = "A system call tracer for Linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mornfall jgeerds ];
  };
}
