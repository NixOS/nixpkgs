{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "gpu-switch-unstable";
  version = "2017-04-28";
  src = fetchFromGitHub {
    owner = "0xbb";
    repo = "gpu-switch";
    rev = "a365f56d435c8ef84c4dd2ab935ede4992359e31";
    sha256 = "1jnh43nijkqd83h7piq7225ixziggyzaalabgissyxdyz6szcn0r";
  };
  installPhase = ''
    mkdir -p $out/bin
    cp gpu-switch $out/bin/
  '';
  meta = with lib; {
    description = "Application that allows to switch between the graphic cards of dual-GPU MacBook Pro models";
    mainProgram = "gpu-switch";
    homepage = "https://github.com/0xbb/gpu-switch";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.msiedlarek ];
  };
}
