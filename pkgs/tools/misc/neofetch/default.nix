{ lib, stdenvNoCC, fetchFromGitHub, bash, makeWrapper, pciutils, ueberzug }:

stdenvNoCC.mkDerivation rec {
  pname = "neofetch";
  version = "unstable-2020-11-26";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = "6dd85d67fc0d4ede9248f2df31b2cd554cca6c2f";
    sha256 = "sha256-PZjFF/K7bvPIjGVoGqaoR8pWE6Di/qJVKFNcIz7G8xE=";
  };

  strictDeps = true;
  buildInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];
  postPatch = ''
    patchShebangs --host neofetch
  '';

  postInstall = ''
    wrapProgram $out/bin/neofetch \
      --prefix PATH : ${lib.makeBinPath [ pciutils ueberzug ]}
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ];

  meta = with lib; {
    description = "A fast, highly customizable system info script";
    homepage = "https://github.com/dylanaraps/neofetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ alibabzo konimex ];
  };
}
