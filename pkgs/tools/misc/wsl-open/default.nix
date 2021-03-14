{ lib, stdenv, fetchFromGitHub, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "wsl-open";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "4U6U57";
    repo = "wsl-open";
    rev = "v${version}";
    sha256 = "1mwak846zh47p3pp4q5f54cw8d9qk61zn43q81j2pkcm35mv9lzg";
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    install -m0755 -D wsl-open.sh $out/bin/wsl-open
    installManPage wsl-open.1
  '';

  meta = with lib; {
    description = "Open files with xdg-open from Windows Subsystem for Linux (WSL) in Windows applications";
    homepage = "https://gitlab.com/4U6U57/wsl-open";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
