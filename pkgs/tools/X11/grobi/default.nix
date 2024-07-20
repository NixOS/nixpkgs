{ lib, fetchFromGitHub, buildGoModule, fetchpatch }:

buildGoModule rec {
  version = "0.6.0";
  pname = "grobi";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "fd0";
    repo = "grobi";
    hash = "sha256-evgDY+OjfQ0ngf4j/D4yOeITHQXmBmw8KiJhLKjdVAw=";
  };

  vendorHash = "sha256-cvP8M9pW58WwHvhXTMYqivNVGzHjDYlOd8/PvnLpfMU=";

  patches = [
    # fix failing test on go 1.15
    (fetchpatch {
      url = "https://github.com/fd0/grobi/commit/176988ab087ff92d1408fbc454c77263457f3d7e.patch";
      hash = "sha256-YfjRV7kQxxGw3nQgB12tZOAJKBW21d9xx6BSou0bHkk=";
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/fd0/grobi";
    description = "Automatically configure monitors/outputs for Xorg via RANDR";
    license = with licenses; [ bsd2 ];
    platforms   = platforms.linux;
    mainProgram = "grobi";
  };
}
