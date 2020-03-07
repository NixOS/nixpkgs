{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "scdoc";
  version = "1.10.1";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/scdoc/archive/${version}.tar.gz";
    sha256 = "13x7g1r56bshvfmlvapvz35ywnbgsh337kywb5kcv8nc6b3j3q40";
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
    homepage = https://git.sr.ht/~sircmpwn/scdoc;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
