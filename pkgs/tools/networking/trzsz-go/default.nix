{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, gnome
}:

buildGoModule rec {
  pname = "trzsz-go";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = "trzsz-go";
    rev = "v${version}";
    hash = "sha256-Uivb8tGiQ+5RUrx1pVefZSl8EKybGLqZR+DhZp+8B7M=";
  };

  vendorHash = "sha256-kZu0q/E3NWcYGRBQNoScBm3dXLcmVNtgrZFrhvA2wps=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/trzsz \
      --prefix PATH ":" "${lib.makeBinPath [ gnome.zenity ]}";
  '';

  meta = with lib; {
    description = "A simple SSH file transfer tools similar to lrzsz written in Go";
    homepage = "https://github.com/trzsz/trzsz-go";
    mainProgram = "trzsz";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
