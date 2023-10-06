{ buildGoModule
, fetchFromGitHub
, lib
, wl-clipboard
, makeWrapper
, installShellFiles
}:

buildGoModule rec {
  pname = "clipman";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "yory8";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lahya0w1bgcTnpxANxNT2MIWu5yVUdqQl19kQzwUdAw=";
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
    homepage = "https://github.com/yory8/clipman";
    description = "A simple clipboard manager for Wayland";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux;
  };
}
