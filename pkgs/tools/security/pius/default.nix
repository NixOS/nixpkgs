{ fetchurl, stdenv, python, gnupg }:

let version = "2.0.11"; in
stdenv.mkDerivation {
  name = "pius-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://sourceforge/pgpius/pius/${version}/pius-${version}.tar.bz2";
    sha256 = "0pdbyqz6k0bm182cz81ss7yckmpms5qhrrw0wcr4a1srzcjyzf5f";
  };

  buildInputs = [ python ];

  patchPhase = ''
    sed -i "pius" -e's|/usr/bin/gpg|${gnupg}/bin/gpg|g'
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin"
    cp -v pius "$out/bin"

    mkdir -p "$out/doc/pius-${version}"
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

    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.gnu;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
