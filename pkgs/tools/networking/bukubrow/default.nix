{ lib, rustPlatform, fetchFromGitHub, sqlite }: let

manifest = {
  description = "Bukubrow extension host application";
  name = "com.samhh.bukubrow";
  path = "@out@/bin/bukubrow";
  type = "stdio";
};

in rustPlatform.buildRustPackage rec {
  pname = "bukubrow-host";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "SamHH";
    repo = pname;
    rev = "v${version}";
    sha256 = "1a3gqxj6d1shv3w0v9m8x2xr0bvcynchy778yqalxkc3x4vr0nbn";
  };

  cargoSha256 = "0z6i9wzz5gy9rs8cxfmwg4mpfajv0xvj4nn6jfl7f1rw6k457jc9";

  buildInputs = [ sqlite ];

  passAsFile = [ "firefoxManifest" "chromeManifest" ];
  firefoxManifest = builtins.toJSON (manifest // {
    allowed_extensions = [ "bukubrow@samhh.com" ];
  });
  chromeManifest = builtins.toJSON (manifest // {
    allowed_origins = [ "chrome-extension://ghniladkapjacfajiooekgkfopkjblpn/" ];
  });
  postBuild = ''
    substituteAll $firefoxManifestPath firefox.json
    substituteAll $chromeManifestPath chrome.json
  '';
  postInstall = ''
    install -Dm0644 firefox.json $out/lib/mozilla/native-messaging-hosts/com.samhh.bukubrow.json
    install -Dm0644 chrome.json $out/etc/chromium/native-messaging-hosts/com.samhh.bukubrow.json
  '';

  meta = with lib; {
    description = "A WebExtension for Buku, a command-line bookmark manager";
    homepage = "https://github.com/SamHH/bukubrow-host";
    license = licenses.gpl3;
    maintainers = with maintainers; [ infinisil ];
  };
}

