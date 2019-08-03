{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "scdoc-${version}";
  version = "1.9.6";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/scdoc/archive/${version}.tar.gz";
    sha256 = "0a2rxn0pihknvyvfvzib42v9c7zfdg8pi95q40fywwjb9clz59c9";
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
