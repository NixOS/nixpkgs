{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "agdsn-zsh-config";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "agdsn";
    repo = "agdsn-zsh-config";
    rev = "v${version}";
    sha256 = "sha256-79bD3YQcpNTKYvEoKu22gqOKvNH7eZPGS/iU+/4IbAU=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D -m644 zshrc-base-hw.zsh "$out/etc/zsh/zshrc"
    install -D -m644 zshrc-home.zsh "$out/etc/skel/.zshrc"
    install -D -m644 zshrc-home.zsh "$out/etc/zsh/newuser.zshrc.recommended"
    install -D -m644 profile-d-agdsn-zsh-config.sh "$out/etc/profile.d/agdsn-zsh-config.sh"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A modified version of the Grml Zsh configuration specialised for the needs of system administration";
    homepage = "https://github.com/agdsn/agdsn-zsh-config";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fugi ];
  };
}
