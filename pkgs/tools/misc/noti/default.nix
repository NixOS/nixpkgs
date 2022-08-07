{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, fetchurl
, Cocoa
, installShellFiles
}:

buildGoModule rec {
  pname = "noti";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "variadico";
    repo = "noti";
    rev = version;
    sha256 = "12r9wawwl6x0rfv1kahwkamfa0pjq24z60az9pn9nsi2z1rrlwkd";
  };

  patches = [
    # update golang.org/x/sys to fix building on aarch64-darwin
    # using fetchurl because fetchpatch breaks the patch
    (fetchurl {
      url = "https://github.com/variadico/noti/commit/a90bccfdb2e6a0adc2e92f9a4e7be64133832ba9.patch";
      sha256 = "sha256-vSAwuAR9absMSFqGOlzmRZoOGC/jpkmh8CMCVjeleUo=";
    })
  ];

  vendorSha256 = null;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optional stdenv.isDarwin Cocoa;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/variadico/noti/internal/command.Version=${version}"
  ];

  postInstall = ''
    installManPage docs/man/*
  '';

  meta = with lib; {
    description = "Monitor a process and trigger a notification";
    longDescription = ''
      Monitor a process and trigger a notification.

      Never sit and wait for some long-running process to finish. Noti can alert you when it's done. You can receive messages on your computer or phone.
    '';
    homepage = "https://github.com/variadico/noti";
    license = licenses.mit;
    maintainers = with maintainers; [ stites marsam ];
  };
}
