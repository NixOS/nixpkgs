{ fetchurl, stdenv, python, gnupg }:

let version = "2.0.7"; in
stdenv.mkDerivation {
  name = "pius-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://sourceforge/pgpius/pius/${version}/pius-${version}.tar.bz2";
    sha256 = "1iyd3z96vp2g7r6s1v34x3vpxikkcy60f15d84r0qla373zl4xd8";
  };

  buildInputs = [ python ];

  patchPhase =
    '' sed -i "pius" -e's|/usr/bin/gpg|${gnupg}/bin/gpg2|g'
    '';

  buildPhase = "true";

  installPhase =
    '' ensureDir "$out/bin"
       cp -v pius "$out/bin"

       ensureDir "$out/doc/pius-${version}"
       cp -v README "$out/doc/pius-${version}"
    '';

  meta = {
    homepage = http://www.phildev.net/pius/;

    description = "PGP Individual UID Signer (PIUS), quickly and easily sign UIDs on a set of PGP keys";

    longDescription =
      '' This software will allow you to quickly and easily sign each UID on
         a set of PGP keys.  It is designed to take the pain out of the
         sign-all-the-keys part of PGP Keysigning Party while adding security
         to the process.
      '';

    license = "GPLv2";

    platforms = stdenv.lib.platforms.gnu;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
