{ fetchFromGitLab, installShellFiles, lib, python3, stdenv }:

stdenv.mkDerivation rec {
  pname = "nvd";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "khumba";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-kOPcQP2tSym69qSOBwVc2XFO8+uy7bgYIQq4L/orS+A=";
  };

  buildInputs = [ python3 ];

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -m555 -Dt $out/bin src/nvd
    installManPage src/nvd.1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Nix/NixOS package version diff tool";
    homepage = "https://gitlab.com/khumba/nvd";
    license = licenses.asl20;
    maintainers = with maintainers; [ khumba ];
    platforms = platforms.all;
  };
}
