{ lib, stdenv, nix, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "nixos-shell";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixos-shell";
    rev = version;
    sha256 = "sha256-whHBBcthLhEIy2VTaioRZOSZoZR7pk4Qr4DVxwU0r9Y=";
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
