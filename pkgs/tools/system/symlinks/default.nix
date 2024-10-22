{ fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "symlinks";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "brandt";
    repo = "symlinks";
    rev = "v${version}";
    sha256 = "EMWd7T/k4v1uvXe2QxhyPoQKUpKIUANE9AOwX461FgU=";
  };

  buildFlags = [ "CC=${stdenv.cc}/bin/cc" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man8
    cp symlinks $out/bin
    cp symlinks.8 $out/share/man/man8
  '';

  meta = with lib; {
    description = "Find and remedy problematic symbolic links on a system";
    homepage = "https://github.com/brandt/symlinks";
    license = licenses.mit;
    maintainers = with maintainers; [ ckauhaus ];
    platforms = platforms.unix;
    mainProgram = "symlinks";
  };
}
