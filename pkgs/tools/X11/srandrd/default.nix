{ stdenv
, fetchFromGitHub
, libX11
, libXrandr
, libXinerama
}:

stdenv.mkDerivation rec {
  pname = "srandrd";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = pname;
    rev = "v${version}";
    sha256 = "07r1ck2ijj30n19ylndgw75ly9k3815kj9inpxblfnjpwbbw6ic0";
  };

  buildInputs = [ libX11 libXrandr libXinerama ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jceb/srandrd";
    description = "Simple randr daemon";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.utdemir ];
  };

}
