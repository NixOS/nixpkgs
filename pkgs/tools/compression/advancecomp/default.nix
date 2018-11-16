{ stdenv, fetchFromGitHub
, autoreconfHook, zlib }:

stdenv.mkDerivation rec {
  name = "advancecomp-${version}";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "advancecomp";
    rev = "v${version}";
    sha256 = "1pd6czamamrd0ppk5a3a65hcgdlqwja98aandhqiajhnibwldv8x";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    description = ''A set of tools to optimize deflate-compressed files'';
    license = licenses.gpl3 ;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    homepage = https://github.com/amadvance/advancecomp;

  };
}
