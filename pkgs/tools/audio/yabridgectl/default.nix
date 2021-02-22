{ lib, rustPlatform, yabridge }:

rustPlatform.buildRustPackage rec {
  pname = "yabridgectl";
  version = yabridge.version;

  src = yabridge.src;
  sourceRoot = "source/tools/yabridgectl";
  cargoSha256 = "1sjhani8h7ap42yqlnj05sx59jyz2h12qlm1ibv8ldxcpwps0bwy";

  patches = [
    ./libyabridge-from-nix-profiles.patch
  ];

  patchFlags = [ "-p3" ];

  meta = with lib; {
    description = "A small, optional utility to help set up and update yabridge for several directories at once";
    homepage = "https://github.com/robbert-vdh/yabridge/tree/master/tools/yabridgectl";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ metadark ];
  };
}
