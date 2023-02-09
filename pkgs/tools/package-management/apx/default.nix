{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, installShellFiles
, docker
, distrobox
}:

buildGoModule rec {
  pname = "apx";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Vanilla-OS";
    repo = pname;
    rev = version;
    sha256 = "sha256-BswX4Jo/RReM/tXo29V9rIvKjN8ylECPe0oo0FCQcGY=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  postInstall = ''
    mkdir -p $out/etc/apx

    cat > "$out/etc/apx/config.json" <<EOF
    {
      "containername": "apx_managed",
      "image": "docker.io/library/ubuntu",
      "pkgmanager": "apt",
      "distroboxpath": "${distrobox}/bin/distrobox"
    }
    EOF

    wrapProgram $out/bin/apx --prefix PATH : ${lib.makeBinPath [ docker distrobox ]}

    installManPage man/apx.1 man/es/apx.1
  '';

  meta = with lib; {
    description = "The Vanilla OS package manager";
    homepage = "https://github.com/Vanilla-OS/apx";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
