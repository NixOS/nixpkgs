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

  npmDepsHash = "sha256-0eemOn96ciiqdNBZC+cFbcaEvZ5nkV9IndsXOzIgelQ=";

  nativeBuildInputs = [ imagemagick ];

  postInstall = ''
    cp -r priv/static $out/static
  '';

<<<<<<< HEAD
  meta = {
    description = "Frontend for the Mobilizon server";
    homepage = "https://joinmobilizon.org/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Frontend for the Mobilizon server";
    homepage = "https://joinmobilizon.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      minijackson
      erictapen
    ];
  };
}
