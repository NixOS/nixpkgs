{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "scdoc-${version}";
  version = "1.4.1";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/scdoc/snapshot/scdoc-${version}.tar.xz";
    sha256 = "14nabq1hrz5jvilx22yxbqjsd9s4ll0fnl750n1qbyyxw2m6vj9b";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-static" "" \
      --replace "/usr/local" "$out"
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A simple man page generator";
    longDescription = ''
      scdoc is a simple man page generator written for POSIX systems written in
      C99.
    '';
    homepage = https://git.sr.ht/~sircmpwn/scdoc/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
