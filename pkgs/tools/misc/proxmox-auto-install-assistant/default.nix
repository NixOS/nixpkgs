{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  libgcc,
  xorriso,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "proxmox-auto-install-assistant";
  version = "8.2.6";

  src = fetchurl {
    url = "http://download.proxmox.com/debian/pve/dists/bookworm/pve-no-subscription/binary-amd64/proxmox-auto-install-assistant_${version}_amd64.deb";
    sha256 = "0z222x2pvfs0wz3gcqp5gw8gvrp9jmvkgrydn6rja6xy4rh2a9w4";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [
    dpkg
    libgcc
    xorriso
  ];

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp $out/usr/bin/proxmox-auto-install-assistant $out/bin/
  '';

  postFixup = ''
    wrapProgram $out/bin/proxmox-auto-install-assistant \
      --prefix PATH : ${lib.makeBinPath [ xorriso ]}
  '';

  meta = with lib; {
    description = "Proxmox Auto Install Assistant";
    homepage = "https://www.proxmox.com";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ alafranque ];
  };
}
