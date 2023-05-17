{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
}:

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

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    install -D gti $out/bin/gti
    installManPage gti.6
    installShellCompletion --cmd gti \
      --bash completions/gti.bash \
      --zsh completions/gti.zsh
  '';

  meta = with lib; {
    homepage = "https://r-wos.org/hacks/gti";
    license = licenses.mit;
    description = "Humorous typo-based git runner; drives a car over the terminal";
    maintainers = with maintainers; [ fadenb ];
    platforms = platforms.unix;
  };
}
