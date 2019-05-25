{ stdenv, rustPlatform, fetchFromGitHub, sqlite }:

rustPlatform.buildRustPackage rec {
  name = "bukubrow-${version}";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "SamHH";
    repo = "bukubrow";
    rev = version;
    sha256 = "1wrwav7am73bmgbpwh1pi0b8k7vhydqvw91hmmhnvbjhrhbns7s5";
  };
  sourceRoot = "source/binary";

  cargoSha256 = "0553awiba24a3a8xwjhlwf8yzbs44lnirjvcxnvsgah7dc44r0gj";

  buildInputs = [ sqlite ];

  postInstall = ''
    mkdir -p $out/etc $out/lib/mozilla/native-messaging-hosts

    host_file="$out/bin/bukubrow"
    sed -e "s!%%replace%%!$host_file!" browser-hosts/firefox.json > "$out/etc/firefox-host.json"
    sed -e "s!%%replace%%!$host_file!" browser-hosts/chrome.json > "$out/etc/chrome-host.json"

    ln -s $out/etc/firefox-host.json $out/lib/mozilla/native-messaging-hosts/com.samhh.bukubrow.json
  '';

  meta = with stdenv.lib; {
    description = "Bukubrow is a WebExtension for Buku, a command-line bookmark manager";
    homepage = https://github.com/SamHH/bukubrow;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ infinisil ];
  };
}

