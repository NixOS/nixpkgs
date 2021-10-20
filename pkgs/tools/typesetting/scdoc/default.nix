{ lib, stdenv, fetchFromSourcehut }:

stdenv.mkDerivation rec {
  pname = "scdoc";
  version = "1.11.1";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = pname;
    rev = version;
    sha256 = "1g37j847j3h4a4qbbfbr6vvsxpifj9v25jgv25nd71d1n0dxlhvk";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-static" "" \
      --replace "/usr/local" "$out"
  '';

  doCheck = true;

  meta = with lib; {
    description = "A simple man page generator";
    longDescription = ''
      scdoc is a simple man page generator written for POSIX systems written in
      C99.
    '';
    homepage = "https://git.sr.ht/~sircmpwn/scdoc";
    changelog = "https://git.sr.ht/~sircmpwn/scdoc/refs/${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
