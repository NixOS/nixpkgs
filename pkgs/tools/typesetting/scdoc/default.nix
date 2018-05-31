{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "scdoc-${version}";
  version = "1.3.3";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/scdoc/snapshot/scdoc-${version}.tar.xz";
    sha256 = "1xkfsrzpbm68522b1dml9dghnwb5dlwpf91c1i4y51rgv3hdgwdj";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "VERSION=1.2.3" "VERSION=${version}" \
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
