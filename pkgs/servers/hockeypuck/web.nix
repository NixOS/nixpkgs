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

  meta = with lib; {
    description = "OpenPGP Key Server web resources";
    homepage = "https://github.com/hockeypuck/hockeypuck";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
