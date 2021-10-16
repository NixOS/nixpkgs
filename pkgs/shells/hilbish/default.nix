{ lib, buildGoModule, fetchFromGitHub, readline }:

buildGoModule rec {
  pname = "hilbish";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "Hilbish";
    rev = "v${version}";
    sha256 = "sha256-557Je9KeBpkZxVAxcjWAhybIJJYlzhtbnIyZh0rCRUc=";
    fetchSubmodules = true;
  };

  vendorSha256 = "sha256-8l+Kb1ADMLwv0Hf/ikok8eUcEEST07rhk8BjHxJI0lc=";

  buildInputs = [ readline ];

  ldflags = [ "-s" "-w" ];

  postPatch = ''
    # in master vars.go is called vars_linux.go
    substituteInPlace vars.go \
      --replace "/usr/share" "${placeholder "out"}/share/"
  '';

  postInstall = ''
    mkdir -p "$out/share/hilbish"

    cp .hilbishrc.lua $out/share/hilbish/
    cp -r libs -t $out/share/hilbish/
    cp preload.lua $out/share/hilbish/
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
