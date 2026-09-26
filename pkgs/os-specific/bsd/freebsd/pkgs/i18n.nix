{
  mkDerivation,
  mkcsmapper,
  mkesdb,
}:

mkDerivation {
  path = "share/i18n";

  noLibc = true;

  extraNativeBuildInputs = [
    mkcsmapper
    mkesdb
  ];

  preBuild = ''
    export makeFlags="$makeFlags ESDBDIR=$out/share/i18n/esdb CSMAPPERDIR=$out/share/i18n/csmapper"
  '';
}
