{ lib, stdenvNoCC, fetchFromGitHub, bash, makeWrapper, pciutils }:

stdenvNoCC.mkDerivation rec {
  pname = "neofetch";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = version;
    sha256 = "0i7wpisipwzk0j62pzaigbiq42y1mn4sbraz4my2jlz6ahwf00kv";
  };

  strictDeps = true;
  buildInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];
  postPatch = ''
    patchShebangs --host neofetch
  '';

  postInstall = ''
    wrapProgram $out/bin/neofetch \
      --prefix PATH : ${lib.makeBinPath [ pciutils ]}
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
