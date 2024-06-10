{ lib,
  fetchFromGitHub,
  buildPythonPackage,
  openvpn,
  iproute2,
  iptables,
  util-linux
}:

buildPythonPackage rec {
  pname = "namespaced-openvpn";
  version = "0.6.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "slingamn";
    repo = pname;
    rev = "a3fa42b2d8645272cbeb6856e26a7ea9547cb7d1";
    sha256 = "+Fdaw9EGyFGH9/DSeVJczS8gPzAOv+qn+1U20zQBBqQ=";
  };

  buildInputs = [ openvpn iproute2 util-linux ];

  postPatch = ''
    substituteInPlace namespaced-openvpn \
      --replace-fail "/usr/sbin/openvpn" "${openvpn}/bin/openvpn" \
      --replace-fail "/sbin/ip" "${iproute2}/bin/ip" \
      --replace-fail "/usr/bin/nsenter" "${util-linux}/bin/nsenter" \
      --replace-fail "/bin/mount" "${util-linux}/bin/mount" \
      --replace-fail "/bin/umount" "${util-linux}/bin/umount"

    substituteInPlace seal-unseal-gateway \
      --replace-fail "/sbin/iptables" "${iptables}/bin/iptables"
  '';

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/bin
    cp namespaced-openvpn seal-unseal-gateway $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/slingamn/namespaced-openvpn";
    description = "Network namespace isolation for OpenVPN tunnels";
    license = licenses.mit;
    maintainers = [ maintainers.lodi ];
    platforms = platforms.linux;
    mainProgram = "namespaced-openvpn";
  };
}
