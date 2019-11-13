{stdenv, go, fetchFromGitHub}:

stdenv.mkDerivation rec{
  pname = "nixos-shell";
  version = "2015-05-23";
  src = fetchFromGitHub {
    owner = "wavewave";
    repo = pname;
    fetchSubmodules = true;
    rev = "1e896190f7971e963efed6c3db45c6783dc9032b";
    sha256 = "1sjp9vawybiqr4pa6aryqgz17vixnywml17x4maiirw11v4marhb";
  };
  buildInputs = [ go ];
  phases = [ "buildPhase" ];
  buildPhase =
    ''
    mkdir -p $out/bin
    GOPATH=$src HOME="." go build -o $out/bin/nixos-shell nixos-shell
    '';
  meta = with stdenv.lib;{
    homepage = https://github.com/wavewave/nixos-shell ;
    description = "Spawn ephemeral development environments in containers,like nix-shell only more";
    license = licenses.free;
    platform = platforms.linux;
  };
}
