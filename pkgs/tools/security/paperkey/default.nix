{ fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "paperkey";
  version = "1.6";

  src = fetchurl {
    url = "https://www.jabberwocky.com/software/paperkey/${pname}-${version}.tar.gz";
    sha256 = "1xq5gni6gksjkd5avg0zpd73vsr97appksfx0gx2m38s4w9zsid2";
  };

  postPatch = ''
    for a in checks/*.sh ; do
      substituteInPlace $a \
        --replace /bin/echo echo
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Store OpenPGP or GnuPG on paper";
    longDescription = ''
      A reasonable way to achieve a long term backup of OpenPGP (GnuPG, PGP, etc)
      keys is to print them out on paper. Paper and ink have amazingly long
      retention qualities - far longer than the magnetic or optical means that
      are generally used to back up computer data.
    '';
    homepage = "https://www.jabberwocky.com/software/paperkey/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ AndersonTorres peterhoeg ];
  };
}
