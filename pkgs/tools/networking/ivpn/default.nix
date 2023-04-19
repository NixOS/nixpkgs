{ buildGoModule
, fetchFromGitHub
, lib
, wirelesstools
, makeWrapper
, wireguard-tools
, openvpn
, obfs4
, iproute2
, dnscrypt-proxy2
, iptables
, gawk
, util-linux
}:

builtins.mapAttrs (pname: attrs: buildGoModule (attrs // rec {
  inherit pname;
  version = "3.10.15";

  src = fetchFromGitHub {
    owner = "ivpn";
    repo = "desktop-app";
    rev = "v${version}";
    hash = "sha256-3yVRVM98tVjot3gIkUb/CDwmwKdOOBjBjzGL6htDtpk=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ivpn/desktop-app/daemon/version._version=${version}"
    "-X github.com/ivpn/desktop-app/daemon/version._time=1970-01-01"
  ];

  postInstall = ''
    mv $out/bin/{${attrs.modRoot},${pname}}
  '';

  meta = with lib; {
    description = "Official IVPN Desktop app";
    homepage = "https://www.ivpn.net/apps";
    changelog = "https://github.com/ivpn/desktop-app/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ataraxiasjel ];
  };
})) {
  ivpn = {
    modRoot = "cli";
    vendorHash = "sha256-T49AE3SUmdP3Tu9Sp5C/QryKDto/NzEqRuUQ3+aJFL0=";
  };
  ivpn-service = {
    modRoot = "daemon";
    vendorHash = "sha256-9Rk6ruMpyWtQe+90kw4F8OLq7/JcDSrG6ufkfcrS4W8=";
    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ wirelesstools ];

    patches = [ ./permissions.patch ];
    postPatch = ''
      substituteInPlace daemon/service/platform/platform_linux.go \
        --replace 'openVpnBinaryPath = "/usr/sbin/openvpn"' \
        'openVpnBinaryPath = "${openvpn}/bin/openvpn"' \
        --replace 'routeCommand = "/sbin/ip route"' \
        'routeCommand = "${iproute2}/bin/ip route"'

      substituteInPlace daemon/netinfo/netinfo_linux.go \
        --replace 'retErr := shell.ExecAndProcessOutput(log, outParse, "", "/sbin/ip", "route")' \
        'retErr := shell.ExecAndProcessOutput(log, outParse, "", "${iproute2}/bin/ip", "route")'

      substituteInPlace daemon/service/platform/platform_linux_release.go \
        --replace 'installDir := "/opt/ivpn"' "installDir := \"$out\"" \
        --replace 'obfsproxyStartScript = path.Join(installDir, "obfsproxy/obfs4proxy")' \
        'obfsproxyStartScript = "${obfs4}/bin/obfs4proxy"' \
        --replace 'wgBinaryPath = path.Join(installDir, "wireguard-tools/wg-quick")' \
        'wgBinaryPath = "${wireguard-tools}/bin/wg-quick"' \
        --replace 'wgToolBinaryPath = path.Join(installDir, "wireguard-tools/wg")' \
        'wgToolBinaryPath = "${wireguard-tools}/bin/wg"' \
        --replace 'dnscryptproxyBinPath = path.Join(installDir, "dnscrypt-proxy/dnscrypt-proxy")' \
        'dnscryptproxyBinPath = "${dnscrypt-proxy2}/bin/dnscrypt-proxy"'
    '';

    postFixup = ''
      mkdir -p $out/etc
      cp -r $src/daemon/References/Linux/etc/* $out/etc/
      cp -r $src/daemon/References/common/etc/* $out/etc/

      patchShebangs --build $out/etc/firewall.sh $out/etc/splittun.sh $out/etc/client.down $out/etc/client.up

      wrapProgram "$out/bin/ivpn-service" \
        --suffix PATH : ${lib.makeBinPath [ iptables gawk util-linux ]}
    '';
  };
}
