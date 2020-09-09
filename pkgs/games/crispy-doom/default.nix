{ stdenv, autoreconfHook, pkgconfig, SDL2, SDL2_mixer, SDL2_net, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "crispy-doom";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1b6gn0dysv631jynh769whww9xcss1gms78sz3nrn855q1dsvcb4";
  };

  patches = [
    # Fixes CVE-2020-14983
    (fetchpatch {
      url = "https://github.com/chocolate-doom/chocolate-doom/commit/f1a8d991aa8a14afcb605cf2f65cd15fda204c56.diff";
      sha256 = "1z6pxg9azcqq7g09hjc09d01knd803nhqilkw2kbx8648hil9mgn";
    })
    (fetchpatch {
      url = "https://github.com/chocolate-doom/chocolate-doom/commit/54fb12eeaa7d527defbe65e7e00e37d5feb7c597.diff";
      sha256 = "0ww21jn02ld73rkp06f7fqy92jqv8c9q4d1mvsryag1gmvy57znj";
    })
  ];

  postPatch = ''
    sed -e 's#/games#/bin#g' -i src{,/setup}/Makefile.am
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ SDL2 SDL2_mixer SDL2_net ];
  enableParallelBuilding = true;

  meta = {
    homepage = "http://fabiangreffrath.github.io/crispy-doom";
    description = "A limit-removing enhanced-resolution Doom source port based on Chocolate Doom";
    longDescription = ''
      Crispy Doom is a limit-removing enhanced-resolution Doom source port based on Chocolate Doom.
      Its name means that 640x400 looks \"crisp\" and is also a slight reference to its origin.
    '';
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ neonfuz ];
  };
}
