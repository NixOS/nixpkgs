{ stdenvNoCC
, lib
, fetchFromGitHub
, bash
, gnused
, gawk
, coreutils
}:

stdenvNoCC.mkDerivation {
  pname = "optparse-bash-unstable";
  version = "2021-06-13";

  src = fetchFromGitHub {
    owner = "nk412";
    repo = "optparse";
    rev = "d86ec17d15368e5b54eb2d47b001b0b61d68bbd0";
    sha256 = "sha256-vs7Jo1+sV0tPse4Wu2xtzSX1IkahwLgO3e4Riz3uMmI=";
  };

  postPatch = ''
    substituteInPlace optparse.bash \
      --replace sed "${gnused}/bin/sed" \
      --replace awk "${gawk}/bin/awk" \
      --replace printf "${coreutils}/bin/printf"
'';

  dontBuild = true;

  doCheck = true;

  nativeCheckInputs = [ bash ];

  # `#!/usr/bin/env` isn't okay for OfBorg
  # Need external bash to run
  checkPhase = ''
    runHook preCheck
    bash ./sample_head.sh -v --file README.md
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv optparse.bash $out/bin/
    mkdir -p $out/share/doc/optparse-bash
    mv README.md sample_head.sh $out/share/doc/optparse-bash/
    runHook postInstall
  '';

  # As example code,
  # sample_head.sh shows how users can use opt-parse in their script,
  # and its shebang (`/usr/bin/env bash`) should not be patched.
  dontPatchShebangs = true;

  meta = with lib; {
    description = "A BASH wrapper for getopts, for simple command-line argument parsing";
    homepage = "https://github.com/nk412/optparse";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
