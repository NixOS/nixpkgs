{ lib 
, stdenv 
, fetchFromGitHub
, libxml2
, libudev
}:

stdenv.mkDerivation rec {
  pname   = "qdl";
  version = "20210506";
  src = fetchFromGitHub {
    owner  = "andersson";
    repo   = "qdl";
    rev    = "2021b303a81ca1bcf21b7f1f23674b5c8747646f";
    sha256 = "0akrdca4jjdkfdya36vy1y5vzimrc4pp5jm24rmlw8hbqxvj72ri";
  };

  buildInputs = [ libxml2 libudev ];

  installPhase = ''
    install -Dm755 ./qdl $out/bin/qdl
  '';

  meta = with lib; {
    homepage    = "https://github.com/andersson/qdl";
    description = "A tool to flash images to Qualcomm devices.";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms   = platforms.linux;
  };
}
