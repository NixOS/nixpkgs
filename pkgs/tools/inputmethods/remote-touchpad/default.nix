{ buildGoModule
, fetchFromGitHub
, lib
, libX11
, libXi
, libXt
, libXtst
}:

buildGoModule rec {
  pname = "remote-touchpad";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XyE8N+YVwfgxToKkhpe8zJ0e3HFDpKt7cfERxWCfbfU=";
  };

  buildInputs = [ libX11 libXi libXt libXtst ];
  tags = [ "portal,x11" ];

  vendorSha256 = "sha256-zTx38kW/ylXXML73C2sFQciV2y3+qbO0S/ZdkiEh5Qs=";

  meta = with lib; {
    description = "Control mouse and keyboard from the webbrowser of a smartphone.";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
