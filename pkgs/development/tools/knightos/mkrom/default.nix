{ stdenv, fetchFromGitHub, cmake, asciidoc }:

stdenv.mkDerivation rec {
  pname = "mkrom";
  version = "unstable-2020-06-11";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "mkrom";
    rev = "7a735ecbe09409e74680a9dc1c50dd4db99a409f";
    sha256 = "18h7a0fb5zb991iy9ljpknmk9qvl9nz3yh1zh5bm399rpxn4nzx3";
  };

  nativeBuildInputs = [
    asciidoc
    cmake
  ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage    = "https://knightos.org/";
    description = "Packages KnightOS distribution files into a ROM";
    license     = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
