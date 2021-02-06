{ stdenv, fetchurl, fetchFromGitHub, requireFile, makeWrapper
, SDL2, SDL2_mixer, cmake, ninja
, Foundation
, fullGame ? false }:

let
  dataZip = if fullGame then requireFile {
    # the data file for the full game
    name = "data.zip";
    sha256 = "1q2pzscrglmwfgdl8yj300wymwskh51iq66l4xcd0qk0q3g3rbkg";
    message = ''
      In order to install VVVVVV, you must first download the game's
      data file (data.zip) as it is not released freely.
      Once you have downloaded the file, place it in your current
      directory, use the following command and re-run the installation:
      nix-prefetch-url file://\$PWD/data.zip
    '';
  } else fetchurl {
    # the data file for the free Make and Play edition
    url = https://thelettervsixtim.es/makeandplay/data.zip;
    name = "mapdata.zip";
    sha256 = "1q2pzscrglmwfgdl8yj300wymwskh51iq66l4xcd0qk0q3g3rbkg";
  };

  # if the user does not own the full game, build the Make and Play edition
  flags = if fullGame then [] else [ "-DMAKEANDPLAY" ];
in stdenv.mkDerivation rec {
  pname = "vvvvvv";
  version = "unstable-2020-02-09";

  src = fetchFromGitHub {
    owner = "TerryCavanagh";
    repo = "VVVVVV";
    rev = "1b00d1260064b384f8b294d15ad5eb43f2dde22b";
    sha256 = "0z98d95ywr30cl6jsxc6ijp2h5p6abgh44ydm5dz9x9zp5rw6zc5";
  };

  CFLAGS = flags;
  CXXFLAGS = flags;

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [
    SDL2 SDL2_mixer
  ] + stdenv.lib.optionalPlatform stdenv.lib.platforms.darwin [ Foundation ];

    sourceRoot = "source/desktop_version";

  installPhase = ''
    install -d $out/bin
    install -t $out/bin VVVVVV
    wrapProgram $out/bin/VVVVVV --add-flags "-assets ${dataZip}"
  '';

  meta = with stdenv.lib; {
    description = "A retro-styled platform game";
    longDescription = ''
      VVVVVV is a platform game all about exploring one simple mechanical
      idea - what if you reversed gravity instead of jumping?
    '';
    homepage = "https://thelettervsixtim.es";
    license = if fullGame then licenses.unfree else licenses.unfreeRedistributable;
    maintainers = [ maintainers.dkudriavtsev ];
    platforms = [ platforms.linux platforms.darwin ];
  };
}
