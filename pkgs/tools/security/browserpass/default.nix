{ stdenv, lib, fetchzip }:
let 
  userDir = "~/.config/chromium";
in
  stdenv.mkDerivation rec {
    name = "browserpass-${version}";

    version = "1.0.2";

    src = fetchzip {
      url = "https://github.com/dannyvankooten/browserpass/releases/download/${version}/browserpass-linux64.zip";
      sha256 = "1fj2siczm472xd1n5i5k08cw94q5gpisfqmvrhhwq7zdjvpcrh8y";
      stripRoot = false;
    };

    dontBuild = true;

    installPhase = ''
      install -D browserpass-linux64 "$out/bin/browserpass"

      host_file="$out/bin/browserpass"
      sed -i -e "s!%%replace%%!$host_file!" chrome-host.json
      sed -i -e "s!%%replace%%!$host_file!" firefox-host.json

      install -D chrome-host.json "$out/etc/chrome-host.json"
      install -D firefox-host.json "$out/etc/firefox-host.json"

    '';


    meta = with lib; {
      maintainers = with maintainers; [ cstrahan ];
      platforms   = ["x86_64-linux"];
    };
  }
