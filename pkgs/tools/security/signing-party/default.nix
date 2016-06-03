{stdenv, fetchurl, gnupg, perl, automake111x, autoconf}:

stdenv.mkDerivation rec {
  version = "2.2";
  basename = "signing-party";
  name = "${basename}-${version}";
  src = fetchurl {
    url = "mirror://debian/pool/main/s/${basename}/${basename}_${version}.orig.tar.gz";
    sha256 = "13qncdyadw1cnslc2xss9s2rpkalm7rz572b23p7mqcdqp30cpdd";
  };

  sourceRoot = ".";

  preBuild = ''
    substituteInPlace sig2dot/Makefile --replace "\$(DESTDIR)/usr" "$out"
    substituteInPlace gpgsigs/Makefile --replace "\$(DESTDIR)/usr" "$out"
    substituteInPlace keylookup/Makefile --replace "\$(DESTDIR)/usr" "$out"
    substituteInPlace springgraph/Makefile --replace "\$(DESTDIR)/usr" "$out"
    substituteInPlace keyanalyze/Makefile --replace "\$(DESTDIR)/usr" "$out"
  '';

  # - perl is required for its pod2man (used in caff)
  buildInputs = [ automake111x autoconf perl gnupg ];

  patches = [ ./gpgwrap_makefile.patch ];

  installFlags = [ "DESTDIR=\${out}" ];

  doCheck = false; # no check rule

  meta = {
    description = "A collection for all kinds of pgp related things, including signing scripts, party preparation scripts etc";
    homepage = http://pgp-tools.alioth.debian.org;
    platforms = gnupg.meta.platforms;
    license = stdenv.lib.licenses.gpl2;
  };
}
