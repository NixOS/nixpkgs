{ stdenv, fetchFromGitHub, libX11, libXtst, pkgconfig, xorgproto, libXi }:

stdenv.mkDerivation rec {
  pname = "ksuperkey";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "hanschen";
    repo = "ksuperkey";
    rev = "v${version}";
    sha256 = "1dvgf356fihfav8pjzww1q6vgd96c5h18dh8vpv022g9iipiwq8a";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 libXtst xorgproto libXi ];

  meta = with stdenv.lib; {
    description = "A tool to be able to bind the super key as a key rather than a modifier";
    homepage = "https://github.com/hanschen/ksuperkey";
    license = licenses.gpl3;
    maintainers = [ maintainers.vozz ];
    platforms = platforms.linux;
  };
}
