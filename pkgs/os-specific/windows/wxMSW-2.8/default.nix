{ stdenv, fetchurl, compat24 ? false, compat26 ? true, unicode ? true
, hostPlatform
}:

stdenv.mkDerivation {
  name = "wxMSW-2.8.11";

  src = fetchurl {
    url = mirror://sourceforge/wxwindows/wxWidgets-2.8.11.tar.gz;
    sha256 = "0icxd21g18d42n1ygshkpw0jnflm03iqki6r623pb5hhd7fm2ksj";
  };

  configureFlags = [
    (if compat24 then "--enable-compat24" else "--disable-compat24")
    (if compat26 then "--enable-compat26" else "--disable-compat26")
    "--disable-precomp-headers"
    (if unicode then "--enable-unicode" else "")
    "--with-opengl"
  ];

  preConfigure = "
    substituteInPlace configure --replace /usr /no-such-path
  ";

  postBuild = "(cd contrib/src && make)";

  postInstall = "
    (cd contrib/src && make install)
    (cd $out/include && ln -s wx-*/* .)
  ";

  passthru = {inherit compat24 compat26 unicode;};

  meta = {
    platforms = stdenv.lib.platforms.windows;
  };
}
