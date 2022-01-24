{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tinyssh";
  version = "20220101";

  src = fetchFromGitHub {
    owner = "janmojzis";
    repo = "tinyssh";
    rev = version;
    sha256 = "sha256-3GW7WNUy7539dN2ckd/0PejzsiaCXcOIMR5FlZKBkMo=";
  };

  preConfigure = ''
    echo /bin       > conf-bin
    echo /share/man > conf-man
  '';

  DESTDIR = placeholder "out";

  meta = with lib; {
    description = "minimalistic SSH server";
    homepage = "https://tinyssh.org";
    license = licenses.publicDomain;
    platforms = platforms.unix;
    maintainers = [ maintainers.kaction ];
  };
}
