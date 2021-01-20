{ lib, stdenv, nix, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "nixos-shell";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixos-shell";
    rev = version;
    sha256 = "sha256-C0K20X0P4SYQV+xtQAUcEiX32kr3IF1RoYdkJ4R3aRM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/nixos-shell \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Spawns lightweight nixos vms in a shell";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
