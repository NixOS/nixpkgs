{ stdenv, bash, nix, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  name = "nixos-shell-${version}";
  version = "0.0.1";

  buildInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixos-shell";
    sha256 = "1rdv55s3597xyxc2rxc96wswcydh62h9jlrcnwhzrpdinzikafny";
    rev = version;
  };

  preConfigure = ''
    export PREFIX=$out
  '';

  postFixup = ''
    wrapProgram $out/bin/nixos-shell \
      --prefix PATH : "${nix}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Spawns lightweight nixos vms in a shell";
    homepage = https://github.com/Mic92/nixos-shell;
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;
  };
}
