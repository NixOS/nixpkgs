{ pkgs, fetchurl, stdenv }:
stdenv.mkDerivation rec {
  name    = "pam_u2f-${version}";
  version = "0.0.1";
  src     = fetchurl {
    url = "https://developers.yubico.com/pam-u2f/Releases/${name}.tar.gz";
    sha256 = "0p1wia4nfw5h0pmy1lcgwsbrlm7z39v1n37692lgqfzyg1kmpv7l";
  };
  buildInputs = with pkgs; [ asciidoc autoconf automake docbook_xml_dtd_45 libtool libu2f-host libu2f-server libxml2 libxslt pkgconfig pam ];

  installFlags = [
    "PAMDIR=$(out)/lib/security"
  ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/pam-u2f/;
    description = "A PAM module for allowing authentication with a U2F device";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ philandstuff ];
  };
}
