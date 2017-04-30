{ stdenv, fetchFromGitHub
, autoreconfHook, zlib }:

stdenv.mkDerivation rec {
  name = "advancecomp-${version}";
  version = "1.23";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "advancecomp";
    rev = "v${version}";
    sha256 = "1mrgmpjd9f7x16g847h1588mgryl26hlzfl40bc611259bb0bq7w"; 
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
