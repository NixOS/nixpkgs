{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gti";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "rwos";
    repo = "gti";
    rev = "v${version}";
    sha256 = "sha256-x6ncvnZPPrVcQYwtwkSenW+ri0L6FpuDa7U7uYUqiyk=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace 'CC=cc' 'CC=${stdenv.cc.targetPrefix}cc'
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man6
    cp gti $out/bin
    cp gti.6 $out/share/man/man6
  '';

  meta = with lib; {
    homepage = "https://r-wos.org/hacks/gti";
    license = licenses.mit;
    description = "Humorous typo-based git runner; drives a car over the terminal";
    maintainers = with maintainers; [ fadenb ];
    platforms = platforms.unix;
  };
}
