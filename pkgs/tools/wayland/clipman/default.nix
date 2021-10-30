{ buildGoModule
, fetchFromGitHub
, lib
, wl-clipboard
, makeWrapper
}:

buildGoModule rec {
  pname = "clipman";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "yory8";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Yq71nYNL3bFvwhVzrQ1g8n7/4tMmLuYUJ9pMBmxL8e8=";
  };

  vendorSha256 = "sha256-Z/sVCJz/igPDdeczC6pemLub6X6z4ZGlBwBmRsEnXKI=";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/clipman \
      --prefix PATH : ${lib.makeBinPath [ wl-clipboard ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/yory8/clipman";
    description = "A simple clipboard manager for Wayland";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux;
  };
}
