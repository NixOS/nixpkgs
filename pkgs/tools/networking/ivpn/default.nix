{ buildGoModule
, fetchFromGitHub
, lib
, wirelesstools
}:

builtins.mapAttrs (pname: attrs: buildGoModule (attrs // rec {
  inherit pname;
  version = "3.10.0";
  src = fetchFromGitHub {
    owner = "ivpn";
    repo = "desktop-app";
    rev = "v${version}";
    hash = "sha256-oX1PWIBPDcvBTxstEiN2WosiVUNXJoloppkpcABSi7Y=";
  };
  ldflags = [
    "-s"
    "-w"
    "-X github.com/ivpn/desktop-app/daemon/version._version=${version}"
    "-X github.com/ivpn/desktop-app/daemon/version._time=1970-01-01"
  ];
  postInstall = "mv $out/bin/{${attrs.modRoot},${pname}}";
  meta = with lib; {
    description = "Official IVPN Desktop app";
    homepage = "https://www.ivpn.net/apps";
    changelog = "https://github.com/ivpn/desktop-app/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
  };
})) {
  ivpn = {
    modRoot = "cli";
    vendorHash = "sha256-5FvKR1Kz91Yi/uILVFyJRnwFZSmZ5qnotXqOI4fKLbY=";
  };
  ivpn-service = {
    modRoot = "daemon";
    vendorHash = "sha256-9Rk6ruMpyWtQe+90kw4F8OLq7/JcDSrG6ufkfcrS4W8=";
    buildInputs = [wirelesstools];
  };
}
