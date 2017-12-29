{ stdenv, fetchurl, perl, perlPackages, finger_bsd, makeWrapper
, abook ? null
, gnupg ? null
, goobook ? null
, khard ? null
}:

let
  version = "0.44";
in
with stdenv.lib;
with perlPackages;
stdenv.mkDerivation {
  name = "lbdb-${version}";
  src = fetchurl {
    url = "http://www.spinnaker.de/debian/lbdb_${version}.tar.gz";
    sha256 = "0kjz3n2ilrg6yrz8z40714ppdprgwhbgvzcsjzs822l6da4qxna3";
  };

  buildInputs = [ goobook makeWrapper perl ConvertASN1 NetLDAP AuthenSASL ]
    ++ optional (!stdenv.isDarwin) finger_bsd
    ++ optional   (abook != null) abook
    ++ optional   (gnupg != null) gnupg
    ++ optional (goobook != null) goobook
    ++ optional   (khard != null) khard;
  configureFlags = [ ]
    ++ optional   (abook != null) "--with-abook"
    ++ optional   (gnupg != null) "--with-gpg"
    ++ optional (goobook != null) "--with-goobook"
    ++ optional   (khard != null) "--with-khard";

  patches = [ ./add-methods-to-rc.patch ];
  postFixup = "wrapProgram $out/lib/mutt_ldap_query --prefix PERL5LIB : "
    + "${AuthenSASL}/${perl.libPrefix}"
    + ":${ConvertASN1}/${perl.libPrefix}"
    + ":${NetLDAP}/${perl.libPrefix}";

  meta = {
    homepage = http://www.spinnaker.de/lbdb/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    description = "The Little Brother's Database";
  };
}
