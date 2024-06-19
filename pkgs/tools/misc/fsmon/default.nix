{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "fsmon";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "nowsecure";
    repo = "fsmon";
    rev = "refs/tags/${version}";
    hash = "sha256-vAlAnGeFMgLIKaqUusBV7QalYh0+dZdifUvZwebk65U=";
  };

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with lib; {
    description = "FileSystem Monitor utility";
    homepage = "https://github.com/nowsecure/fsmon";
    changelog = "https://github.com/nowsecure/fsmon/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.linux;
    mainProgram = "fsmon";
  };
}
