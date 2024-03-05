{ lib, stdenv, fetchFromGitHub, libX11, libXtst, pkg-config, xorgproto, libXi }:

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

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libX11 libXtst xorgproto libXi ];

  meta = with lib; {
    description = "A tool to be able to bind the super key as a key rather than a modifier";
    homepage = "https://github.com/hanschen/ksuperkey";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "ksuperkey";
  };
}
