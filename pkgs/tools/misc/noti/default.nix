{ stdenv, lib, buildGoPackage, fetchFromGitHub
, Cocoa ? null }:

buildGoPackage rec {
  pname = "noti";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "variadico";
    repo = "noti";
    rev = version;
    sha256 = "1lw1wmw2m83m0s5znb4gliywjpg74qrhrj6rwpcb5p352c4vbwxs";
  };

  buildInputs = lib.optional stdenv.isDarwin Cocoa;
  # TODO: Remove this when we update apple_sdk
  NIX_CFLAGS_COMPILE = lib.optional stdenv.isDarwin "-fno-objc-arc";

  goPackagePath = "github.com/variadico/noti";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X ${goPackagePath}/internal/command.Version=${version}")
  '';

  postInstall = ''
    install -Dm444 -t $out/share/man/man1 $src/docs/man/*.1
    install -Dm444 -t $out/share/man/man5 $src/docs/man/*.5
  '';

  meta = with lib; {
    description = "Monitor a process and trigger a notification.";
    longDescription = ''
      Monitor a process and trigger a notification.

      Never sit and wait for some long-running process to finish. Noti can alert you when it's done. You can receive messages on your computer or phone.
    '';
    homepage = https://github.com/variadico/noti;
    license = licenses.mit;
    maintainers = with maintainers; [ stites ];
    platforms = platforms.all;
  };
}
