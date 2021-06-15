{ lib, stdenv, fetchurl, fetchpatch, perl, finger_bsd
, abook ? null
, gnupg ? null
, goobook ? null
, khard ? null
, mu ? null
}:

let
  version = "0.48.1";
  perl' = perl.withPackages (p: with p; [ ConvertASN1 perlldap AuthenSASL ]);
in
stdenv.mkDerivation {
  pname = "lbdb";
  inherit version;
  src = fetchurl {
    url = "https://www.spinnaker.de/lbdb/download/lbdb_${version}.tar.gz";
    sha256 = "1gr5l2fr9qbdccga8bhsrpvz6jxigvfkdxrln9wyf2xpps5cdjxh";
  };

  buildInputs = [ goobook perl' ]
    ++ lib.optional (!stdenv.isDarwin) finger_bsd
    ++ lib.optional   (abook != null) abook
    ++ lib.optional   (gnupg != null) gnupg
    ++ lib.optional (goobook != null) goobook
    ++ lib.optional   (khard != null) khard
    ++ lib.optional      (mu != null) mu;

  configureFlags = [ ]
    ++ lib.optional   (abook != null) "--with-abook"
    ++ lib.optional   (gnupg != null) "--with-gpg"
    ++ lib.optional (goobook != null) "--with-goobook"
    ++ lib.optional   (khard != null) "--with-khard"
    ++ lib.optional      (mu != null) "--with-mu";

  patches = [ ./add-methods-to-rc.patch
    # fix undefined exec_prefix. Remove with the next release
    (fetchpatch {
      url = "https://github.com/RolandRosenfeld/lbdb/commit/60b7bae255011f59212d96adfbded459d6a27129.patch";
      sha256 = "129zg086glmlalrg395jq8ljcp787dl3rxjf9v7apsd8mqfdkl2v";
      excludes = [ "debian/changelog" ];
    })
  ];

  meta = with lib; {
    homepage = "https://www.spinnaker.de/lbdb/";
    license = licenses.gpl2;
    platforms = platforms.all;
    description = "The Little Brother's Database";
    maintainers = [ maintainers.kaiha maintainers.bfortz ];
  };
}
