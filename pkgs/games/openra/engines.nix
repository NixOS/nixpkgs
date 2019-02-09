{ buildOpenRAEngine, fetchFromGitHub, abbrevCommit, extraPostFetch }:

let
  buildUpstreamOpenRAEngine = { version, rev, sha256 }: name: (buildOpenRAEngine {
    inherit version;
    description = "Open-source re-implementation of Westwood Studios' 2D Command and Conquer games";
    homepage = https://www.openra.net/;
    mods = [ "cnc" "d2k" "ra" "ts" ];
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "OpenRA" ;
      inherit rev sha256 extraPostFetch;
    };
  } name).overrideAttrs (origAttrs: {
    postInstall = ''
      ${origAttrs.postInstall}
      cp -r mods/ts $out/lib/openra/mods/
      cp mods/ts/icon.png $(mkdirp $out/share/pixmaps)/openra-ts.png
      ( cd $out/share/applications; sed -e 's/Dawn/Sun/g' -e 's/cnc/ts/g' openra-cnc.desktop > openra-ts.desktop )
    '';
  });

in {
  release = name: (buildUpstreamOpenRAEngine rec {
    version = "20181215";
    rev = "${name}-${version}";
    sha256 = "0p0izykjnz7pz02g2khp7msqa00jhjsrzk9y0g29dirmdv75qa4r";
  } name);

  playtest = name: (buildUpstreamOpenRAEngine rec {
    version = "20190106";
    rev = "${name}-${version}";
    sha256 = "0ps9x379plrrj1hnj4fpr26lc46mzgxknv5imxi0bmrh5y4781ql";
  } name);

  bleed = buildUpstreamOpenRAEngine {
    version = "9c9cad1";
    rev = "9c9cad1a15c3a34dc2a61b305e4a9a735381a5f8";
    sha256 = "0100p7wrnnlvkmy581m0gbyg3cvi4i1w3lzx2gq91ndz1sbm8nd2";
  };
}
