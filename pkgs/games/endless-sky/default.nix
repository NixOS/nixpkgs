{ stdenv, fetchFromGitHub, fetchpatch
, SDL2, libpng, libjpeg, glew, openal, scons, libmad
}:

let
  version = "0.9.12";

in
stdenv.mkDerivation {
  pname = "endless-sky";
  inherit version;

  src = fetchFromGitHub {
    owner = "endless-sky";
    repo = "endless-sky";
    rev = "v${version}";
    sha256 = "1hly68ljm7yv01jfxyr7g6jivhj0igg6xx7vi92zqymick0hlh7a";
  };

  patches = [
    (fetchpatch {
      name = "endless-sky-gcc10.patch";
      url = "https://github.com/endless-sky/endless-sky/commit/bc3cab5992694547f9c6c067b5579ef06224781b.patch";
      sha256 = "0v3913jyzhh1d81dxv738kcd3xhh7mrl06qnmj7a3ya2xd9pq4dk";
    })
    ./fixes.patch
  ];

  enableParallelBuilding = true;

  buildInputs = [
    SDL2 libpng libjpeg glew openal scons libmad
  ];

  prefixKey = "PREFIX=";

  meta = with stdenv.lib; {
    description = "A sandbox-style space exploration game similar to Elite, Escape Velocity, or Star Control";
    homepage = "https://endless-sky.github.io/";
    license = with licenses; [
      gpl3Plus cc-by-sa-30 cc-by-sa-40 publicDomain
    ];
    maintainers = with maintainers; [ lheckemann ];
    platforms = platforms.linux; # Maybe other non-darwin Unix
  };
}
