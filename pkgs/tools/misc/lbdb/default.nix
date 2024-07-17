{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  perl,
  bsd-finger,
  withAbook ? true,
  abook,
  withGnupg ? true,
  gnupg,
  withGoobook ? true,
  goobook,
  withKhard ? true,
  khard,
  withMu ? true,
  mu,
}:

let
  perl' = perl.withPackages (
    p: with p; [
      AuthenSASL
      ConvertASN1
      IOSocketSSL
      perlldap
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "lbdb";
  version = "0.48.1";

  src = fetchurl {
    url = "https://www.spinnaker.de/lbdb/download/lbdb_${version}.tar.gz";
    sha256 = "1gr5l2fr9qbdccga8bhsrpvz6jxigvfkdxrln9wyf2xpps5cdjxh";
  };

  buildInputs =
    [ perl' ]
    ++ lib.optional (!stdenv.isDarwin) bsd-finger
    ++ lib.optional withAbook abook
    ++ lib.optional withGnupg gnupg
    ++ lib.optional withGoobook goobook
    ++ lib.optional withKhard khard
    ++ lib.optional withMu mu;

  configureFlags =
    [ ]
    ++ lib.optional withAbook "--with-abook"
    ++ lib.optional withGnupg "--with-gpg"
    ++ lib.optional withGoobook "--with-goobook"
    ++ lib.optional withKhard "--with-khard"
    ++ lib.optional withMu "--with-mu";

  patches = [
    ./add-methods-to-rc.patch
    # fix undefined exec_prefix. Remove with the next release
    (fetchpatch {
      url = "https://github.com/RolandRosenfeld/lbdb/commit/60b7bae255011f59212d96adfbded459d6a27129.patch";
      sha256 = "129zg086glmlalrg395jq8ljcp787dl3rxjf9v7apsd8mqfdkl2v";
      excludes = [ "debian/changelog" ];
    })
  ];

  meta = with lib; {
    homepage = "https://www.spinnaker.de/lbdb/";
    description = "The Little Brother's Database";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      kaiha
      bfortz
    ];
    platforms = platforms.all;
  };
}
