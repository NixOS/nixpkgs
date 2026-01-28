{
  lib,
  mkKdeDerivation,
  replaceVars,
  pkg-config,
  qtwebengine,
  mobile-broadband-provider-info,
  openconnect,
  openvpn,
  strongswan,
}:
let
  vpns = {
    openvpn = lib.getExe openvpn;
    strongswan = lib.getExe' strongswan "ipsec";
  };
in
mkKdeDerivation {
  pname = "plasma-nm";

  patches = [
    (replaceVars ./vpn-bin-path.patch vpns)
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtwebengine
    mobile-broadband-provider-info
    openconnect
  ];

  # Manually register UTF-16 QString paths so Nix knows about hidden runtime dependencies
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${lib.concatStringsSep ":" (lib.attrValues vpns)}" > $out/nix-support/depends
  '';
}
