{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "uni2ascii-4.18";
  src = fetchurl {
    url = "http://billposer.org/Software/Downloads/${name}.tar.gz";
    sha256 = "03lklnzr6ngs4wqiqa7rifd246f441gfvardbsaa5l6fn9pbn94y";
  };

  meta = {
    license = stdenv.lib.licenses.gpl3;
    homepage = http://billposer.org/Software/uni2ascii.html;
    description = "Converts between UTF-8 and many 7-bit ASCII equivalents and back";

    longDescription = '' 
    This package provides conversion in both directions between UTF-8
    Unicode and more than thirty 7-bit ASCII equivalents, including
    RFC 2396 URI format and RFC 2045 Quoted Printable format, the
    representations used in HTML, SGML, XML, OOXML, the Unicode
    standard, Rich Text Format, POSIX portable charmaps, POSIX locale
    specifications, and Apache log files, and the escapes used for
    including Unicode in Ada, C, Common Lisp, Java, Pascal, Perl,
    Postscript, Python, Scheme, and Tcl.

    Such ASCII equivalents are useful when including Unicode text in
    program source, when debugging, and when entering text into web
    programs that can handle the Unicode character set but are not
    8-bit safe. For example, MovableType, the blog software, truncates
    posts as soon as it encounters a byte with the high bit
    set. However, if Unicode is entered in the form of HTML numeric
    character entities, Movable Type will not garble the post.

    It also provides ways of converting non-ASCII characters to
    similar ASCII characters, e.g. by stripping diacritics.
    '';
    maintainers = [ "cillian.deroiste@gmail.com" ];
    platforms = stdenv.lib.platforms.linux;
  };
}
