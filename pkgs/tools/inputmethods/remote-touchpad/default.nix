{ buildGoModule
, fetchFromGitHub
, lib
, libXi
, libXrandr
, libXt
, libXtst
}:

buildGoModule rec {
  pname = "remote-touchpad";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nsLPqLnup7hGPFzAjxi/40A4fGPB+4m+aIrfNjbxgUY=";
  };

  buildInputs = [ libXi libXrandr libXt libXtst ];
  tags = [ "portal,x11" ];

  vendorHash = "sha256-p1XhhXyWdfwgoDEjO/3trB1dm2bAogPydt/MZOg4YmE=";

  meta = with lib; {
    description = "Control mouse and keyboard from the webbrowser of a smartphone.";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
