{ stdenv, fetchFromGitHub, libxslt, docbook_xsl, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_checksums";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "credativ";
    repo = pname;
    rev = version;
    sha256 = "0xc2bwp55xjnnf45lc60ldxpb5jfyi1bgfkv3nxrymcswh8yfidj";
  };

  nativeBuildInputs = [ libxslt.bin ];

  buildInputs = [ postgresql ];

  buildFlags = [ "all" "man" ];

  preConfigure = ''
    substituteInPlace doc/stylesheet-man.xsl \
      --replace "http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl" "${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
  '';

  installPhase = ''
    install -Dm755 -t $out/bin pg_checksums
    install -Dm644 -t $out/share/man/man1 doc/man1/pg_checksums.1
  '';

  meta = with stdenv.lib; {
    description = "Activate/deactivate/verify checksums in offline PostgreSQL clusters";
    homepage = "https://github.com/credativ/pg_checksums";
    maintainers = [ maintainers.marsam ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
