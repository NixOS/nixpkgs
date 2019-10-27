{ stdenv, fetchurl, fetchpatch, perl, perlPackages, finger_bsd, makeWrapper
, abook ? null
, gnupg ? null
, goobook ? null
, khard ? null
, mu ? null
}:

let
  version = "0.48.1";
in
with stdenv.lib;
with perlPackages;
stdenv.mkDerivation {
  pname = "lbdb";
  inherit version;
  src = fetchurl {
    url = "http://www.spinnaker.de/lbdb/download/lbdb_${version}.tar.gz";
    sha256 = "1gr5l2fr9qbdccga8bhsrpvz6jxigvfkdxrln9wyf2xpps5cdjxh";
  };

  buildInputs = [ goobook makeWrapper perl ConvertASN1 perlldap AuthenSASL ]
    ++ optional (!stdenv.isDarwin) finger_bsd
    ++ optional   (abook != null) abook
    ++ optional   (gnupg != null) gnupg
    ++ optional (goobook != null) goobook
    ++ optional   (khard != null) khard
    ++ optional      (mu != null) mu;
  configureFlags = [ ]
    ++ optional   (abook != null) "--with-abook"
    ++ optional   (gnupg != null) "--with-gpg"
    ++ optional (goobook != null) "--with-goobook"
    ++ optional   (khard != null) "--with-khard"
    ++ optional      (mu != null) "--with-mu";

  patches = [ ./add-methods-to-rc.patch
    # fix undefined exec_prefix. Remove with the next release
    (fetchpatch {
      url = "https://github.com/RolandRosenfeld/lbdb/commit/60b7bae255011f59212d96adfbded459d6a27129.patch";
      sha256 = "129zg086glmlalrg395jq8ljcp787dl3rxjf9v7apsd8mqfdkl2v";
      excludes = [ "debian/changelog" ];
    })
  ];
  postFixup = "wrapProgram $out/lib/mutt_ldap_query --prefix PERL5LIB : "
    + "${AuthenSASL}/${perl.libPrefix}"
    + ":${ConvertASN1}/${perl.libPrefix}"
    + ":${perlldap}/${perl.libPrefix}";

  meta = {
    homepage = http://www.spinnaker.de/lbdb/;
    license = licenses.gpl2;
    platforms = platforms.all;
    description = "The Little Brother's Database";
    maintainers = [ maintainers.kaiha maintainers.bfortz ];
  };
}
