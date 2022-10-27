{ lib, stdenv, fetchFromGitHub, libxml2, systemd }:

stdenv.mkDerivation {
  pname   = "qdl";
  version = "unstable-2021-05-06";

  src = fetchFromGitHub {
    owner  = "andersson";
    repo   = "qdl";
    rev    = "2021b303a81ca1bcf21b7f1f23674b5c8747646f";
    sha256 = "0akrdca4jjdkfdya36vy1y5vzimrc4pp5jm24rmlw8hbqxvj72ri";
  };

  buildInputs = [ systemd libxml2 ];

  installPhase = ''
    runHook preInstall
    install -Dm755 ./qdl -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage    = "https://github.com/andersson/qdl";
    description = "Tool for flashing images to Qualcomm devices";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ muscaln ];
    platforms   = platforms.linux;
  };
}
