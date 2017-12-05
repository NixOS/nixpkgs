{stdenv, fetchurl, SDL, lua5_1, pkgconfig, SDL_mixer, SDL_image, SDL_ttf}:
stdenv.mkDerivation rec {
  name = "fish-fillets-ng-${version}";
  version = "1.0.1";
  src = fetchurl {
    url = "mirror://sourceforge/fillets/fillets-ng-${version}.tar.gz";
    sha256 = "1nljp75aqqb35qq3x7abhs2kp69vjcj0h1vxcpdyn2yn2nalv6ij";
  };
  data = fetchurl {
    url = "mirror://sourceforge/fillets/fillets-ng-data-${version}.tar.gz";
    sha256 = "169p0yqh2gxvhdilvjc2ld8aap7lv2nhkhkg4i1hlmgc6pxpkjgh";
  };
  buildInputs = [SDL lua5_1 pkgconfig SDL_mixer SDL_image SDL_ttf];
  postInstall=''
    mkdir -p "$out/share/games/fillets-ng/"
    tar -xf ${data} -C "$out/share/games/fillets-ng/" --strip-components=1
  '';
  meta = {
    inherit version;
    description = ''A puzzle game'';
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://fillets.sourceforge.net/;
  };
}
