{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {

  pname = "idsk";
  version = "0.19";

  src = fetchFromGitHub {
    repo = "idsk";
    owner = "cpcsdk";
    rev = "v${version}";
    sha256 = "0b4my5cz5kbzh4n65jr721piha6zixaxmfiss2zidip978k9rb6f";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/bin
    cp iDSK $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Manipulating CPC dsk images and files";
    homepage = "https://github.com/cpcsdk/idsk" ;
    license = licenses.mit;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
