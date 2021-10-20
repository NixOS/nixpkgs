{ lib, buildGoModule, fetchFromGitHub, readline }:

buildGoModule rec {
  pname = "hilbish";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "Hilbish";
    rev = "v${version}";
    sha256 = "sha256-ACHHHGT3VGnvZVi1UZb57+g/slcld5e3bh+DDhUVVpQ=";
    fetchSubmodules = true;
  };

  vendorSha256 = "sha256-SVGPMFpQjVOWCfiPpEmqhp6MEO0wqeyAZVyeNmTuXl0=";

  buildInputs = [ readline ];

  ldflags = [ "-s" "-w" ];

  postPatch = ''
    substituteInPlace vars_linux.go \
      --replace "/usr/share" "${placeholder "out"}/share/"
  '';

  postInstall = ''
    mkdir -p "$out/share/hilbish"

    cp .hilbishrc.lua $out/share/hilbish/
    cp -r docs -t $out/share/hilbish
    cp -r libs -t $out/share/hilbish/
    cp preload.lua $out/share/hilbish/

    # segfaults and it's already been generated upstream
    # we copy the docs over with the above cp command
    rm $out/bin/docgen
  '';

  meta = with lib; {
    description = "An interactive Unix-like shell written in Go";
    changelog = "https://github.com/Rosettea/Hilbish/releases/tag/v${version}";
    homepage = "https://github.com/Rosettea/Hilbish";
    maintainers = with maintainers; [ fortuneteller2k ];
    license = licenses.mit;
    platforms = platforms.linux; # only officially supported on Linux
  };
}
