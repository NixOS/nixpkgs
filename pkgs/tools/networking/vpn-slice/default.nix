{
  lib,
  stdenv,
  buildPythonApplication,
  nix-update-script,
  fetchFromGitHub,
  dnspython,
  iproute2,
  iptables,
  setproctitle,
  setuptools,
  unixtools,
}:

buildPythonApplication rec {
  pname = "vpn-slice";
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dlenski";
    repo = "vpn-slice";
    rev = "v${version}";
    sha256 = "sha256-T6VULLNRLWO4OcAsuTmhty6H4EhinyxQSg0dfv2DUJs=";
  };

  postPatch =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace vpn_slice/mac.py \
        --replace-fail "'/sbin/route'" "'${unixtools.route}/bin/route'"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace vpn_slice/linux.py \
        --replace-fail "'/sbin/ip'" "'${iproute2}/bin/ip'" \
        --replace-fail "'/sbin/iptables'" "'${iptables}/bin/iptables'"
    '';

  build-system = [
    setuptools
  ];

  dependencies = [
    setuptools # can be removed with next package update, upstream no longer has a dependency on distutils
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
    maintainers = [ ];
  };
}
