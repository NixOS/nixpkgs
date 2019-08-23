{ stdenv, fetchFromGitHub, SDL2, SDL2_image, SDL2_mixer }:

stdenv.mkDerivation rec {
  pname = "abbaye-des-morts";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "nevat";
    repo = "abbayedesmorts-gpl";
    rev = "v${version}";
    sha256 = "1pwqf7r9bqb2p3xrw9i7y8pgr1401fy3mnnqpb1qkhmdl3gqi9hb";
  };

  buildInputs = [ SDL2 SDL2_image SDL2_mixer ];

  makeFlags = [ "PREFIX=$(out)" "DESTDIR=" ];

  preBuild = stdenv.lib.optionalString stdenv.cc.isClang
    ''
      substituteInPlace Makefile \
        --replace -fpredictive-commoning ""
    '';

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
  '';

  meta = with stdenv.lib; {
    homepage = "https://locomalito.com/abbaye_des_morts.php";
    description = "A retro arcade video game";
    license = licenses.gpl3;
    maintainers = [ maintainers.marius851000 ];
  };
}
