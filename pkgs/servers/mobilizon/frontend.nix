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

  npmDepsHash = "sha256-5ilhuFaIvksXsJmNu20m8MV3hYtyPUz4zp8NIvhR5Nw=";

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
