{ stdenv, fetchFromGitHub
, autoreconfHook, zlib }:

stdenv.mkDerivation rec {
  name = "advancecomp-${version}";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "advancecomp";
    rev = "v${version}";
    sha256 = "1lvrcxcxbxac47j0ml11nikx38zan7bbr3dfjssm52r5v4cmh8j9";
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
