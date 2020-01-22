{ stdenv, fetchurl, fetchFromGitHub, requireFile
, SDL2, SDL2_mixer, cmake, ninja
, fullGame ? false }:

let
  dataZip = if fullGame then requireFile {
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
    url = https://thelettervsixtim.es/makeandplay/data.zip;
    sha256 = "1q2pzscrglmwfgdl8yj300wymwskh51iq66l4xcd0qk0q3g3rbkg";
  };
in stdenv.mkDerivation rec {
  pname = "vvvvvv";
  version = "2.3-git-2a514b2";

  src = fetchFromGitHub {
    owner = "TerryCavanagh";
    repo = "VVVVVV";
    rev = "90cab340f123f1a355f638c47b677c6572a514b2";
    sha256 = "1bq7kj33pw1dwsgh0s0pqayfyhpnbvpgw2c1w9scpl5l0hkhg44p";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ SDL2 SDL2_mixer ];

  preConfigure = ''
    cd desktop_version
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -t $out/bin VVVVVV
    cp ${dataZip} $out/bin/data.zip
  '';

  meta = with stdenv.lib; {
    description = "A platform game based on flipping gravity";
    longDescription = ''
      VVVVVV is a platform game all about exploring one simple mechanical
      idea - what if you reversed gravity instead of jumping? 
    '';
    homepage = https://thelettervsixtim.es;
    license = licenses.unfree;
    maintainers = [ maintainers.dkudriavtsev ];
    platforms = platforms.all;
  };
}
