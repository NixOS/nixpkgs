{ fetchFromGitHub, openttd, zstd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
<<<<<<< HEAD
  version = "0.54.4";
=======
  version = "0.53.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
<<<<<<< HEAD
    hash = "sha256-bTpHlKffQbANXIrAn9WSEK/PEzBW1nzaHhGKIyclAo0=";
  };

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];

  meta = {
    homepage = "https://github.com/JGRennison/OpenTTD-patches";
    changelog = "https://github.com/JGRennison/OpenTTD-patches/blob/jgrpp-${version}/jgrpp-changelog.md";
  };

=======
    hash = "sha256-+5AOsop3x1fkX5UfxMFLhrTLeSnt+E0PYoU5n31N3f4=";
  };

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
})
