{ cpio, fetchurl, fixDarwinDylibNames, lib, stdenvNoCC, undmg, unpkg, unzip }:
{ description, homepage, license, maintainers, pname, sha256, url, version }:

stdenvNoCC.mkDerivation rec {
  inherit pname version;

  nativeBuildInputs = [ cpio fixDarwinDylibNames undmg unpkg unzip ];

  sourceRoot = ".";
  src = fetchurl {
    name = builtins.replaceStrings [ "%20" ] [ "-" ] (builtins.head (builtins.match ".*/([^/]+)" url));
    inherit url sha256;
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
      # .dmg files or compressed Applications
      app=( ./*.app )
      if [ ! -z "$app" ]; then
        mkdir -p $out/Applications
        mv -n "$app" $out/Applications/
      fi

      # .pkg files
      if [ -d "./usr/local" ]; then
        mv -n ./usr/local/* $out/
      fi

      if [ ! -L "./Applications" ] && [ -d "./Applications" ]; then
        mkdir -p $out/Applications
        mv -n ./Applications/*.app $out/Applications/
      fi
    '';

  meta = with lib; {
    description = description;
    homepage = homepage;
    license = licenses."${license}";
    maintainers = forEach maintainers (x: maintainers."${maintainer}");
    platforms = platforms.darwin;
  };
}
