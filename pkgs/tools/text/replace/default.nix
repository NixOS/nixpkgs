{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "replace-2.24";

  src = fetchurl {
    url = ftp://hpux.connect.org.uk/hpux/Users/replace-2.24/replace-2.24-src-11.11.tar.gz;
    sha256 = "1c2nkxx83vmlh1v3ib6r2xqh121gdb1rharwsimcb2h0xwc558dm";
  };

  buildInputs = [];
  makeFlags = " TREE=\$(out) ";

  meta = {
    description = "
	Replace verbatim strings. Sed is not fit to do it. Replace is.
";
  };
}
