{ callPackage, stdenv, maven, src, version }:

let
  skeinRepo = callPackage ./skeinrepo.nix { inherit src version; };
in
stdenv.mkDerivation rec {
  pname = "skein.jar";

  inherit version src;

  nativeBuildInputs = [ maven ];

  buildPhase = ''
    mvn --offline -f java/pom.xml package -Dmaven.repo.local="${skeinRepo}" -Dskein.version=${version} -Dversion=${version}
  '';

  installPhase = ''
    # Making sure skein.jar exists skips the maven build in setup.py
    mv java/target/skein-*.jar $out
  '';
}
