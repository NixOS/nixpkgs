{ stdenv, ghcWithPackages, gtk3, makeWrapper }:

let
leksahEnv = ghcWithPackages (self: [ self.leksah-server self.leksah self.cabal-install ]);
in stdenv.mkDerivation {
  name = "leksah-${leksahEnv.version}";

  buildInputs = [ gtk3 ];
  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${leksahEnv}/bin/leksah $out/bin/leksah \
      --prefix PATH : "${leksahEnv}/bin" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = {
    broken = true; # 2018-09-13, no successful hydra build since 2017-08-19
  };
}
