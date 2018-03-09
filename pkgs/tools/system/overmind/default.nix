{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper,
  which, tmux }:

buildGoPackage rec {
  name = "overmind-${version}";
  version = "1.1.1";

  goPackagePath = "github.com/DarthSim/overmind";

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = "overmind";
    rev = "v${version}";
    sha256 = "0gdsbm54ln07jv1kgg53fiavx18xxw4f21lfcdl74ijk6bx4jbzv";
  };

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram ''${!outputBin}/bin/overmind --prefix PATH : \
      ${stdenv.lib.makeBinPath [ which tmux ]}
  '';

  meta = {
    description = "Process manager for Procfile-based applications and tmux";
    homepage = https://github.com/DarthSim/overmind;
    license = stdenv.lib.licenses.mit;
  };
}
