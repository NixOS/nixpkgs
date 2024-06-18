{ lib, stdenv, nix, jq, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "nixos-shell";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixos-shell";
    rev = version;
    sha256 = "sha256-r5qNuv8MAo9He2g2jMPYlpxwaMzKomDvxvjNoS0JKDI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/nixos-shell \
      --prefix PATH : ${lib.makeBinPath [ nix jq ]}
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Spawns lightweight nixos vms in a shell";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
    mainProgram = "nixos-shell";
  };
}
