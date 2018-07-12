{ stdenv, fetchFromGitHub, SDL2, SDL2_image, openal, libvorbis, zlib, curl,
  libGL, makeWrapper, boost }:

stdenv.mkDerivation rec {
  name = "keeperrl-${version}";
  version = "alpha24";

  src = fetchFromGitHub {
    owner = "miki151";
    repo = "keeperrl";
    rev = "${version}";
    sha256 = "00vpq4njdl8hqndjvx2r0w0azz9lfil4qg1rlhj3y9qvc1i0xwwn";
  };

  patches = [ ./makefile_cflags.patch ];

  buildInputs = [
    SDL2 SDL2_image openal libvorbis zlib curl libGL makeWrapper
  ] ++ stdenv.lib.optional stdenv.isDarwin boost ;

  makeFlags = [ "OPT=true" "RELEASE=true" ];

  CFLAGS = "-I${SDL2.dev}/include/SDL2";

  installPhase = ''
    mkdir -p $out/keeperrl
    mkdir -p $out/bin
    cp ./keeper $out/bin/
    cp -r data_contrib data_free  $out/keeperrl
    wrapProgram $out/bin/keeper \
      --run 'mkdir -p $HOME/.keeperrl' \
      --run 'cd $HOME/.keeperrl' \
      --run "rm data_free || true" \
      --run "rm data_contrib || true" \
      --run "ln -s $out/keeperrl/data_free ." \
      --run "ln -s $out/keeperrl/data_contrib ."
  '';

  meta = with stdenv.lib; {
    homepage = http://keeperrl.com/;
    description = "Ambitious dungeon builder with roguelike elements";
    maintainers = with maintainers; [ rardiol ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
