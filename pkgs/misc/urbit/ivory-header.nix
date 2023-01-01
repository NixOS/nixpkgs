{ urbit-src
, runCommandLocal
, fetchGitHubLFS
, xxd
}: let
  lfs = fetchGitHubLFS {
    src = "${urbit-src}/bin/ivory.pill";
  };
in runCommandLocal "ivory-header" {} ''
    mkdir -p $out/include
    cat ${lfs} > u3_Ivory.pill
    ${xxd}/bin/xxd -i u3_Ivory.pill > $out/include/ivory_impl.h
  ''
