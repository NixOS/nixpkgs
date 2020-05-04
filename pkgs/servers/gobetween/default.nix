{ buildGoModule, fetchFromGitHub, lib, enableStatic ? false }:

buildGoModule rec {
  pname = "gobetween";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "yyyar";
    repo = "gobetween";
    rev = version;
    sha256 = "f01593509ccece063acd47002c4fc52261fbbbcdbf14b088d813b7d8e38fcca8";
  };

  modSha256 =
    "dd91838d20c99c73447590e43edd13c87755276f17ef3e53f24c5df3d0908f78";

  buildPhase = ''
    make build${lib.optionalString enableStatic "-static"}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/gobetween $out/bin
    cp -r share $out/share
    cp -r config $out/share
  '';

  meta = with lib; {
    description = "Modern & minimalistic load balancer for the Сloud era";
    homepage = "http://gobetween.io";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
  };
}
