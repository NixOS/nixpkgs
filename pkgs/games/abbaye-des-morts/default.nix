{ lib, stdenv, fetchFromGitHub, SDL2, SDL2_image, SDL2_mixer }:

stdenv.mkDerivation rec {
  pname = "abbaye-des-morts";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "nevat";
    repo = "abbayedesmorts-gpl";
    rev = "v${version}";
    sha256 = "sha256-/RAtOL51o3/5pDgqPLJMTtDFY9BpIowM5MpJ88+v/Zs=";
  };

  buildInputs = [ SDL2 SDL2_image SDL2_mixer ];

  makeFlags = [ "PREFIX=$(out)" "DESTDIR=" ];

  preBuild = lib.optionalString stdenv.cc.isClang
    ''
      substituteInPlace Makefile \
        --replace -fpredictive-commoning ""
    '';

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
  '';

  meta = with lib; {
    homepage = "https://locomalito.com/abbaye_des_morts.php";
    description = "Retro arcade video game";
    mainProgram = "abbayev2";
    license = licenses.gpl3;
    maintainers = [ maintainers.marius851000 ];
  };
}
