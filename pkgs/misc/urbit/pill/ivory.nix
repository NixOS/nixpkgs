{ urbit-src, lib, stdenvNoCC, fetchGitHubLFS, bootFakeShip, solid, urbit, arvo, curl, xxd
, withRopsten ? false }:

let

  lfs = fetchGitHubLFS { src = /. + builtins.unsafeDiscardStringContext "${urbit-src}/bin/ivory.pill"; };

in {
  build = import ./builder.nix {
    inherit stdenvNoCC urbit curl;

    name = "ivory" + lib.optionalString withRopsten "-ropsten";
    builder = ./ivory.sh;
    arvo = if withRopsten then arvo.ropsten else arvo;
    pier = bootFakeShip {
      inherit urbit;

      pill = solid.lfs;
      ship = "zod";
    };
  };

  # The hexdump of the `.lfs` pill contents as a C header.
  header = stdenvNoCC.mkDerivation {
    name = "ivory-header";
    src = lfs;
    nativeBuildInputs = [ xxd ];
    phases = [ "installPhase" ];

    installPhase = ''
      file=u3_Ivory.pill

      header "writing $file"

      mkdir -p $out/include
      cat $src > $file
      xxd -i $file > $out/include/ivory_impl.h
    '';

    preferLocalBuild = true;
  };
} // lib.optionalAttrs (!withRopsten) { inherit lfs; }
