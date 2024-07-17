{
  lib,
  callPackage,
  buildNpmPackage,
  imagemagick,
}:

let
  common = callPackage ./common.nix { };
in
buildNpmPackage {
  inherit (common) pname version src;

  npmDepsHash = "sha256-pF07ul71zg9iLM/ja4Fz/6IXpqdMKb7KwOH02Q9lyCg=";

  nativeBuildInputs = [ imagemagick ];

  postInstall = ''
    cp -r priv/static $out/static
  '';

  meta = with lib; {
    description = "Frontend for the Mobilizon server";
    homepage = "https://joinmobilizon.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      minijackson
      erictapen
    ];
  };
}
