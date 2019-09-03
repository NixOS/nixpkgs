{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "scdoc";
  version = "1.9.7";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/scdoc/archive/${version}.tar.gz";
    sha256 = "0y9p03dzdaszx02jbkdf3vcs52fqml591cmic5jdch5yznrg03ky";
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
