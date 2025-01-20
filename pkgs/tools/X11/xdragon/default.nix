{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdragon";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mwh";
    repo = "dragon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wqG6idlVvdN+sPwYgWu3UL0la5ssvymZibiak3KeV7M=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];
  postInstall = ''
    ln -s $out/bin/dragon $out/bin/xdragon
  '';

  meta = with lib; {
    description = "Simple drag-and-drop source/sink for X (called dragon in upstream)";
    homepage = "https://github.com/mwh/dragon";
    license = licenses.gpl3;
    maintainers = with maintainers; [ das_j ];
    mainProgram = "xdragon";
  };
})
