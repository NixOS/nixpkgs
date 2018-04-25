{ fetchFromGitHub, stdenv, pythonPackages, gnupg }:

let version = "2.2.6"; in
pythonPackages.buildPythonApplication {
  name = "pius-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "jaymzh";
    repo = "pius";
    rev = "v${version}";
    sha256 = "1rffwyjd84rwx1w5yyqckirm1kdj80ldfwjlw91kk74swhpbpzzj";
  };

  patchPhase = ''
    for file in libpius/constants.py pius-keyring-mgr; do
      sed -i "$file" -E -e's|/usr/bin/gpg2?|${gnupg}/bin/gpg|g'
    done
  '';

  meta = {
    homepage = https://www.phildev.net/pius/;

    description = "PGP Individual UID Signer (PIUS), quickly and easily sign UIDs on a set of PGP keys";

    longDescription =
      '' This software will allow you to quickly and easily sign each UID on
         a set of PGP keys.  It is designed to take the pain out of the
         sign-all-the-keys part of PGP Keysigning Party while adding security
         to the process.
      '';

    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.gnu;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu kierdavis ];
  };
}
