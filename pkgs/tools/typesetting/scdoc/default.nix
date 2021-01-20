{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "scdoc";
  version = "1.11.1";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/scdoc/archive/${version}.tar.gz";
    sha256 = "007pm3gspvya58cwb12wpnrm9dq5p28max2s0b2y9rq80nqgqag5";
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
