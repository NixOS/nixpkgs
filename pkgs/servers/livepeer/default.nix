{ stdenv, fetchFromGitHub, buildGoPackage
, pkgconfig, ffmpeg
}:

buildGoPackage rec {
  pname = "livepeer";
  version = "0.2.4";

  goPackagePath = "github.com/livepeer/go-livepeer";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    rev = version;
    sha256 = "07vhw787wq5q4xm7zvswjdsmr20pwfa39wfkgamb7hkrffn3k2ia";
  };

  buildInputs = [ pkgconfig ffmpeg ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Official Go implementation of the Livepeer protocol";
    homepage = https://livepeer.org;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ elitak ];
  };
}
