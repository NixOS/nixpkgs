{ stdenv, lib, buildGoModule, fetchFromGitHub
, Cocoa ? null }:

buildGoModule rec {
  pname = "noti";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "variadico";
    repo = "noti";
    rev = version;
    sha256 = "0bcwfyd93fx0rzjc9jgg4pvvqbpxwizr044yqqa5rx70gaasz7qa";
  };

  buildInputs = lib.optional stdenv.isDarwin Cocoa;


  preBuild = ''
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
    homepage = "https://github.com/variadico/noti";
    license = licenses.mit;
    maintainers = with maintainers; [ stites marsam ];
    platforms = platforms.all;
  };
}