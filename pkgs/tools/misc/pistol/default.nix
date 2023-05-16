{ lib
, buildGoModule
, fetchFromGitHub
, file
, installShellFiles
, asciidoctor
}:

buildGoModule rec {
  pname = "pistol";
<<<<<<< HEAD
  version = "0.4.2";
=======
  version = "0.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-7nALrB+QubEnryVsGPpFMJ003SP2lheYTkWXF5w/V8I=";
  };

  vendorHash = "sha256-9Ydps8UA1f0fwG5SHRE4F61OyRJiITw/4SyoMEbsRgM=";
=======
    sha256 = "sha256-umejrLdx8R//o9uQIT9JhAKJOIF5Ifpx7s3x3ejsJgo=";
  };

  vendorHash = "sha256-zs7qzXvOnIiDwwNldMPB4Jkm2GWxVZnLpDzpf+ivhCc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "cmd/pistol" ];

  buildInputs = [
    file
  ];
  nativeBuildInputs = [
    installShellFiles
    asciidoctor
  ];
  postInstall = ''
    asciidoctor -b manpage -d manpage README.adoc
    installManPage pistol.1
  '';

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "General purpose file previewer designed for Ranger, Lf to make scope.sh redundant";
    homepage = "https://github.com/doronbehar/pistol";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
