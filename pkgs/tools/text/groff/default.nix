{ stdenv, fetchurl, ghostscript, perl, groff }:

stdenv.mkDerivation rec {
  name = "groff-1.22.3";

  src = fetchurl {
    url = "mirror://gnu/groff/${name}.tar.gz";
    sha256 = "1998v2kcs288d3y7kfxpvl369nqi06zbbvjzafyvyl3pr7bajj1s";
  };

  outputs = [ "out" "doc" ];

  enableParallelBuilding = false;

  buildInputs = [ ghostscript ];
  nativeBuildInputs = [ perl ];

  # Builds running without a chroot environment may detect the presence
  # of /usr/X11 in the host system, leading to an impure build of the
  # package. To avoid this issue, X11 support is explicitly disabled.
  # Note: If we ever want to *enable* X11 support, then we'll probably
  # have to pass "--with-appresdir", too.
  configureFlags = "--without-x";

  doCheck = true;

  crossAttrs = {
    # Trick to get the build system find the proper 'native' groff
    # http://www.mail-archive.com/bug-groff@gnu.org/msg01335.html
    preBuild = ''
      makeFlags="GROFF_BIN_PATH=${groff}/bin GROFFBIN=${groff}/bin/groff"
    '';
  };

  postInstall = ''
      # Remove example output with (random?) colors to 
      # avoid non-determinism in the output
      rm $doc/share/doc/${name}/examples/hdtbl/*color*ps
      # Remove creation date
      find $doc/share/doc/${name} -type f -print0 | xargs -0 sed -i -e 's/%%CreationDate: .*//'
    '';

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/groff/;
    description = "GNU Troff, a typesetting package that reads plain text and produces formatted output";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];

    longDescription = ''
      groff is the GNU implementation of troff, a document formatting
      system.  Included in this release are implementations of troff,
      pic, eqn, tbl, grn, refer, -man, -mdoc, -mom, and -ms macros,
      and drivers for PostScript, TeX dvi format, HP LaserJet 4
      printers, Canon CAPSL printers, HTML and XHTML format (beta
      status), and typewriter-like devices.  Also included is a
      modified version of the Berkeley -me macros, the enhanced
      version gxditview of the X11 xditview previewer, and an
      implementation of the -mm macros.
    '';
  };
}
