{ stdenv, fetchurl, pcre, libiconv, perl }:

let version = "2.25"; in

stdenv.mkDerivation {
  name = "gnugrep-${version}";

  src = fetchurl {
    url = "mirror://gnu/grep/grep-${version}.tar.xz";
    sha256 = "0c38b67cnwchwzv4wq2gpz6smkhdxrac2hhssv8f0l04qnx867p2";
  };

  # Perl is needed for testing
  nativeBuildInputs = [ perl ];
  outputs = [ "out" "info" ]; # the man pages are rather small

  buildInputs = [ pcre libiconv ];

  # cygwin: FAIL: multibyte-white-space
  # freebsd: FAIL mb-non-UTF8-performance
  # all platforms: timing sensitivity in long-pattern-perf 
  #doCheck = !stdenv.isDarwin && !stdenv.isSunOS && !stdenv.isCygwin && !stdenv.isFreeBSD;
  doCheck = false;

  # On Mac OS X, force use of mkdir -p, since Grep's fallback
  # (./install-sh) is broken.
  preConfigure = ''
    export MKDIR_P="mkdir -p"
  '';

  # Fix reference to sh in bootstrap-tools, and invoke grep via
  # absolute path rather than looking at argv[0].
  postInstall =
    ''
      rm $out/bin/egrep $out/bin/fgrep
      echo "#! /bin/sh" > $out/bin/egrep
      echo "exec $out/bin/grep -E \"\$@\"" >> $out/bin/egrep
      echo "#! /bin/sh" > $out/bin/fgrep
      echo "exec $out/bin/grep -F \"\$@\"" >> $out/bin/fgrep
      chmod +x $out/bin/egrep $out/bin/fgrep
    '';

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/grep/;
    description = "GNU implementation of the Unix grep command";

    longDescription = ''
      The grep command searches one or more input files for lines
      containing a match to a specified pattern.  By default, grep
      prints the matching lines.
    '';

    license = licenses.gpl3Plus;

    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };

  passthru = {inherit pcre;};
}
