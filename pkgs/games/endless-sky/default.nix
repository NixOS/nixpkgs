{ stdenv, fetchFromGitHub
, SDL2, libpng, libjpeg, glew, openal, scons, libmad
}:

let
  version = "0.9.8";

in
stdenv.mkDerivation rec {
  name = "endless-sky-${version}";

  src = fetchFromGitHub {
    owner = "endless-sky";
    repo = "endless-sky";
    rev = "v${version}";
    sha256 = "0i36lawypikbq8vvzfis1dn7yf6q0d2s1cllshfn7kmjb6pqfi6c";
  };

  enableParallelBuilding = true;

  buildInputs = [
    SDL2 libpng libjpeg glew openal scons libmad
  ];

  prefixKey = "PREFIX=";

  patches = [
    ./fixes.patch
  ];

  meta = with stdenv.lib; {
    description = "A sandbox-style space exploration game similar to Elite, Escape Velocity, or Star Control";
    homepage = https://endless-sky.github.io/;
    license = with licenses; [
      gpl3Plus cc-by-sa-30 cc-by-sa-40 publicDomain
    ];
    maintainers = with maintainers; [ lheckemann ];
    platforms = platforms.linux; # Maybe other non-darwin Unix
  };
}
