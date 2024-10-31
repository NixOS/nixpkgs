{ lib, stdenv, autoreconfHook, pkg-config, SDL2, SDL2_mixer, SDL2_net
, fetchFromGitHub, fetchpatch, python3 }:

stdenv.mkDerivation rec {
  pname = "chocolate-doom";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "chocolate-doom";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1zlcqhd49c5n8vaahgaqrc2y10z86xng51sbd82xm3rk2dly25jp";
  };

  patches = [
    # Pull upstream patch to fix builx against gcc-10:
    #   https://github.com/chocolate-doom/chocolate-doom/pull/1257
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/chocolate-doom/chocolate-doom/commit/a8fd4b1f563d24d4296c3e8225c8404e2724d4c2.patch";
      sha256 = "1dmbygn952sy5n8qqp0asg11pmygwgygl17lrj7i0fxa0nrhixhj";
    })
  ];

  outputs = [ "out" "man" ];

  postPatch = ''
    sed -e 's#/games#/bin#g' -i src{,/setup}/Makefile.am
    patchShebangs --build man/{simplecpp,docgen}
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    # for documentation
    python3
  ];
  buildInputs = [ SDL2 SDL2_mixer SDL2_net ];
  enableParallelBuilding = true;

  meta = {
    homepage = "http://chocolate-doom.org/";
    description = "Doom source port that accurately reproduces the experience of Doom as it was played in the 1990s";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    hydraPlatforms = lib.platforms.linux; # darwin times out
    maintainers = [ ];
  };
}
