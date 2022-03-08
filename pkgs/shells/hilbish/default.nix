{ lib, buildGoModule, fetchFromGitHub, readline }:

buildGoModule rec {
  pname = "hilbish";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "Hilbish";
    rev = "v${version}";
    sha256 = "sha256-BsN2v6OEWOtk8ENKr5G+lSmNIUA89VfpO+QQoBizx9g=";
    fetchSubmodules = true;
  };

  vendorSha256 = "sha256-Bmst1oJMuSXGvL8Syw6v2BqrbO5McHKkTufFs6iuxzs=";

  ldflags = [
    "-s"
    "-w"
    "-X main.dataDir=${placeholder "out"}/share/hilbish"
  ];

  postInstall = ''
    mkdir -p "$out/share/hilbish"

    cp .hilbishrc.lua $out/share/hilbish/
    cp -r docs -t $out/share/hilbish
    cp -r libs -t $out/share/hilbish/
    cp -r prelude/ $out/share/hilbish/

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
