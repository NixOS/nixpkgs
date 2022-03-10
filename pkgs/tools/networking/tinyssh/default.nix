{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tinyssh";
  version = "20220305";

  src = fetchFromGitHub {
    owner = "janmojzis";
    repo = "tinyssh";
    rev = version;
    sha256 = "sha256-d49saN0I22DZixx5AdvQmx3WM7yzQH5lOKnKbzhlls0=";
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
