{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, Cocoa
, installShellFiles
}:

buildGoModule rec {
  pname = "noti";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "variadico";
    repo = "noti";
    rev = version;
    sha256 = "sha256-FhVpw6PJcm0aYQBlN7AUjOkJgCzleOHXIXumSegtxfA=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optional stdenv.isDarwin Cocoa;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/variadico/noti/internal/command.Version=${version}"
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  postInstall = ''
    installManPage docs/man/dist/*
  '';

  meta = with lib; {
    description = "Monitor a process and trigger a notification";
    longDescription = ''
      Monitor a process and trigger a notification.

      Never sit and wait for some long-running process to finish. Noti can alert
      you when it's done. You can receive messages on your computer or phone.
    '';
    homepage = "https://github.com/variadico/noti";
    license = licenses.mit;
    maintainers = with maintainers; [ stites marsam ];
  };
}
