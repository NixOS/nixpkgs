{ fetchurl, stdenv, SDL, freealut, SDL_image, openal, physfs, zlib, mesa, jam }:

stdenv.mkDerivation rec {
  name = "trigger-rally-0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/trigger-rally/${name}-src.tar.bz2";
    sha256 = "1fvb6dl5bwclmx0y8ygyrfn8jczc5kxawxlyv6mp592smb5x5hjs";
  };

  srcData = fetchurl {
    url = "mirror://sourceforge/trigger-rally/${name}-data.tar.bz2";
    sha256 = "04f9d74gz5xvfx6pnmbfxqhp0kd1p16j5lrgcq12wxvla6py4qaw";
  };

  buildInputs = [ SDL freealut SDL_image openal physfs zlib mesa jam ];

  preConfigure = ''
    configureFlags="$configureFlags --datadir=$out/share/${name}-data"
  '';

  # It has some problems installing the README file, so... out.
  patchPhase = ''
    sed -i /README/d Jamfile
  '';

  buildPhase = "jam";

  installPhase = ''
    jam install
    mkdir -p $out/share
    pushd $out/share
    tar xf $srcData
  '';

  meta = {
    description = "Rally";
    homepage = http://trigger-rally.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
