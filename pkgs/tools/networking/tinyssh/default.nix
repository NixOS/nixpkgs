{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "tinyssh";
  version = "20240101";

  src = fetchFromGitHub {
    owner = "janmojzis";
    repo = "tinyssh";
    rev = "refs/tags/${version}";
    hash = "sha256-wO0fGr+pU+Y5YCZMRGNOZ6pJeCUIc64TzmRAaQCnBxk=";
  };

  preConfigure = ''
    echo /bin       > conf-bin
    echo /share/man > conf-man
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=implicit-function-declaration";

  DESTDIR = placeholder "out";

  meta = with lib; {
    description = "Minimalistic SSH server";
    homepage = "https://tinyssh.org";
    changelog = "https://github.com/janmojzis/tinyssh/releases/tag/${version}";
    license = licenses.cc0;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kaction ];
  };
}
