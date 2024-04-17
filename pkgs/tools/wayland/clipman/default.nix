{ buildGoModule
, fetchFromGitHub
, lib
, wl-clipboard
, makeWrapper
, installShellFiles
}:

buildGoModule rec {
  pname = "clipman";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-htMApyGuDCjQR+2pgi6KPk+K+GbO63fJWFxl9GW8yfg=";
  };

  vendorHash = "sha256-Z/sVCJz/igPDdeczC6pemLub6X6z4ZGlBwBmRsEnXKI=";

  outputs = [ "out" "man" ];

  doCheck = false;

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  postInstall = ''
    wrapProgram $out/bin/clipman \
      --prefix PATH : ${lib.makeBinPath [ wl-clipboard ]}
    installManPage docs/*.1
  '';

  meta = with lib; {
    homepage = "https://github.com/chmouel/clipman";
    description = "A simple clipboard manager for Wayland";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux;
    mainProgram = "clipman";
  };
}
