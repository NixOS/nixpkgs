{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "scdoc-${version}";
  version = "1.8.0";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/scdoc/archive/${version}.tar.gz";
    sha256 = "11693c01bn2cxmxra9r3nkacl908na4k42h2j4dv5j7zc8081994";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-static" "" \
      --replace "/usr/local" "$out"
    # It happens from time to time that the version wasn't updated:
    sed -iE 's/VERSION=[0-9]\.[0-9]\.[0-9]/VERSION=${version}/' Makefile
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A simple man page generator";
    longDescription = ''
      scdoc is a simple man page generator written for POSIX systems written in
      C99.
    '';
    homepage = https://git.sr.ht/~sircmpwn/scdoc;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
