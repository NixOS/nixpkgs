{ pkgs, stdenv, nixosTests }:
let
  package = (import ./node.nix { inherit pkgs; inherit (stdenv.hostPlatform) system; }).package;
in
package.override rec {
  version = "1.26.0";
  reconstructLock = true;

  src = pkgs.fetchFromGitHub {
    owner = "Koenkk";
    repo = "zigbee2mqtt";
    rev = version;
    sha256 = "eK1Hk+P4pVfv5tk5Nl9GvUjGfcrYO+6mipkqFd8uA74=";
  };

  passthru.tests.zigbee2mqtt = nixosTests.zigbee2mqtt;

  postInstall = ''
    npm run build
  '';

  meta = with pkgs.lib; {
    description = "Zigbee to MQTT bridge using zigbee-shepherd";
    license = licenses.gpl3;
    homepage = "https://github.com/Koenkk/zigbee2mqtt";
    maintainers = with maintainers; [ sweber ];
    platforms = platforms.linux;
  };
}
