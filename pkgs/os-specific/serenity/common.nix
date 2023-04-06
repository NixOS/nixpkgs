{ lib
, stdenvNoCC
, buildPackages
}:

rec {
  rev = "4d87072201efc4ef9086588255fbb1bb993872ab";

  version = "unstable-2023-04-03";

  # Fetch Serenity source and patch shebangs
  src = buildPackages.stdenvNoCC.mkDerivation {
    pname = "serenity-src";
    inherit version;

    src = buildPackages.fetchFromGitHub {
      owner = "SerenityOS";
      repo = "serenity";
      sha256 = "Yb3j/eiGfARLFh1LFySnAFN/Z0xis6erphsLZLyUw9o=";
      inherit rev;
    };

    installPhase = ''
      cp -r . $out
    '';

    dontPatchELF = true;
  };
}
