{ lib, stdenv, fetchurl, makeWrapper, SDL, SDL_image }:

stdenv.mkDerivation rec {
  pname = "airstrike-pre";
  version = "6a";

  src = fetchurl {
    url = "https://icculus.org/airstrike/airstrike-pre${version}-src.tar.gz";
    sha256 = "1h6rv2zcp84ycmd0kv1pbpqjgwx57dw42x7878d2c2vnpi5jn8qi";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ SDL SDL_image ];

  NIX_LDFLAGS = "-lm";

  installPhase = ''
    ls -l
    mkdir -p $out/bin
    cp airstrike $out/bin

    mkdir -p $out/share
    cp -r data airstrikerc $out/share

    wrapProgram $out/bin/airstrike \
      --chdir "$out/share"
  '';

  meta = with lib; {
    description = "A 2d dogfighting game";
    homepage = "https://icculus.org/airstrike/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
