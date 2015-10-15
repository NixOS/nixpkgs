{ stdenv, fetchurl, xz, pcre, libiconv }:

let version = "2.21"; in

stdenv.mkDerivation {
  name = "gnugrep-${version}";

  src = fetchurl {
    url = "mirror://gnu/grep/grep-${version}.tar.xz";
    sha256 = "1pp5n15qwxrw1pibwjhhgsibyv5cafhamf8lwzjygs6y00fa2i2j";
  };

  patches = [ ./cve-2015-1345.patch ];

  outputs = [ "out" "info" ]; # the man pages are rather small

  buildInputs = [ pcre xz.bin libiconv ];

  # cygwin: FAIL: multibyte-white-space
  doCheck = !stdenv.isDarwin && !stdenv.isCygwin;

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
