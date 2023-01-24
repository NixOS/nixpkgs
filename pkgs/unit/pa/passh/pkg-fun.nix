{ lib, fetchFromGitHub, stdenv }:
stdenv.mkDerivation rec {
  pname = "passh";
  version = "2020-03-18";

  src = fetchFromGitHub {
    owner = "clarkwang";
    repo = pname;
    rev = "7112e667fc9e65f41c384f89ff6938d23e86826c";
    sha256 = "1g0rx94vqg36kp46f8v4x6jcmvdk85ds6bkrpayq772hbdm1b5z5";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp passh $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/clarkwang/passh";
    description = "An sshpass alternative for non-interactive ssh auth";
    license = licenses.gpl3;
    maintainers = [ maintainers.lovesegfault ];
    platforms = platforms.unix;
  };
}
