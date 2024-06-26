{
  lib,
  stdenv,
  buildPythonApplication,
  nix-update-script,
  python3Packages,
  fetchFromGitHub,
  iproute2,
  iptables,
  unixtools,
}:

buildPythonApplication rec {
  pname = "vpn-slice";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "dlenski";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-T6VULLNRLWO4OcAsuTmhty6H4EhinyxQSg0dfv2DUJs=";
  };

  postPatch =
    lib.optionalString stdenv.isDarwin ''
      substituteInPlace vpn_slice/mac.py \
        --replace "'/sbin/route'" "'${unixtools.route}/bin/route'"
    ''
    + lib.optionalString stdenv.isLinux ''
      substituteInPlace vpn_slice/linux.py \
        --replace "'/sbin/ip'" "'${iproute2}/bin/ip'" \
        --replace "'/sbin/iptables'" "'${iptables}/bin/iptables'"
    '';

  propagatedBuildInputs = with python3Packages; [
    setproctitle
    dnspython
  ];

  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/dlenski/vpn-slice";
    description = "vpnc-script replacement for easy and secure split-tunnel VPN setup";
    mainProgram = "vpn-slice";
    license = licenses.gpl3;
    maintainers = with maintainers; [ liketechnik ];
  };
}
