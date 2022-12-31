{ urbit-src, lib, stdenvNoCC, fetchGitHubLFS, curl, xxd }:

let
  lfs = fetchGitHubLFS {
    src = /.
      + builtins.unsafeDiscardStringContext "${urbit-src}/bin/ivory.pill";
  };
in stdenvNoCC.mkDerivation {
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
}
