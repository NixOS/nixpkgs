{
  stdenv,
  lib,
  fetchFromGitHub,
  nixosTests,
}:

let
  sources = (import ./sources.nix) { inherit fetchFromGitHub; };
in
stdenv.mkDerivation {
  pname = "${sources.pname}-web";

  inherit (sources) version src;

  dontBuild = true; # We should just copy the web templates

  installPhase = ''
    mkdir -p $out/share/

    cp -vr contrib/webroot $out/share/
    cp -vr contrib/templates $out/share/
  '';

  passthru.tests = nixosTests.hockeypuck;

<<<<<<< HEAD
  meta = {
    description = "OpenPGP Key Server web resources";
    homepage = "https://github.com/hockeypuck/hockeypuck";
    license = lib.licenses.gpl3Plus;
=======
  meta = with lib; {
    description = "OpenPGP Key Server web resources";
    homepage = "https://github.com/hockeypuck/hockeypuck";
    license = licenses.gpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
