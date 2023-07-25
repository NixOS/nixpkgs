{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hd-idle";
  version = "1.20";

  src = fetchFromGitHub {
    owner = "adelolmo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7EXfI3E83ltpjq2M/qZX2P/bNtQQBWZRBCD7i5uit0I=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage debian/hd-idle.8
  '';

  meta = with lib; {
    description = "Spins down external disks after a period of idle time";
    homepage = "https://github.com/adelolmo/hd-idle";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.rycee ];
  };
}
