{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, libevdev
, openssl
, makeWrapper
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "rkvm";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "htrefil";
    repo = pname;
    rev = version;
    hash = "sha256-bWDVc5pWc5gtwGF3vwUgjDhqZP7E79nteKiuAEEbw6E=";
  };

  cargoHash = "sha256-FUaycVxW7QJ5gTZ/8bWjqSaMSepRF5iqlBNJLaDRNxc=";

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook makeWrapper ];
  buildInputs = [ libevdev ];

  postInstall = ''
    install -Dm444 -t "$out/lib/systemd/system" systemd/rkvm-*.service
    install -Dm444 example/server.toml "$out/etc/rkvm/server.example.toml"
    install -Dm444 example/client.toml "$out/etc/rkvm/client.example.toml"

    wrapProgram $out/bin/rkvm-certificate-gen --prefix PATH : ${lib.makeBinPath [ openssl ]}
  '';

  passthru.tests = {
    inherit (nixosTests) rkvm;
  };

  meta = with lib; {
    description = "Virtual KVM switch for Linux machines";
    homepage = "https://github.com/htrefil/rkvm";
    changelog = "https://github.com/htrefil/rkvm/releases/tag/${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ckie ];
  };
}
