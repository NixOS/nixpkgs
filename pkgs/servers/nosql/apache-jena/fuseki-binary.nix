{
  lib,
  stdenv,
  fetchurl,
  java,
  coreutils,
  which,
  makeWrapper,
  # For the test
  pkgs,
}:

stdenv.mkDerivation rec {
  pname = "apache-jena-fuseki";
  version = "5.1.0";
  src = fetchurl {
    url = "mirror://apache/jena/binaries/apache-jena-fuseki-${version}.tar.gz";
    hash = "sha256-GcwXcLVM2txPC+kkHjEIpqK9dTkQEN9Jkka0EaJRO7Q=";
  };
  nativeBuildInputs = [
    makeWrapper
  ];
  installPhase = ''
    cp -r . "$out"
    chmod +x $out/fuseki
    ln -s "$out"/{fuseki-backup,fuseki-server,fuseki} "$out/bin"
    for i in "$out"/bin/fuseki*; do
      # It is necessary to set the default $FUSEKI_BASE directory to a writable location
      # By default it points to $FUSEKI_HOME/run which is in the nix store
      wrapProgram "$i" \
        --prefix "PATH" : "${java}/bin/:${coreutils}/bin:${which}/bin" \
        --set-default "FUSEKI_HOME" "$out" \
        --run "if [ -z \"\$FUSEKI_BASE\" ]; then export FUSEKI_BASE=\"\$HOME/.local/fuseki\" ; mkdir -p \"\$HOME/.local/fuseki\" ; fi" \
        ;
    done
  '';
  passthru = {
    tests = {
      basic-test = pkgs.callPackage ./fuseki-test.nix { };
    };
  };
  meta = with lib; {
    description = "SPARQL server";
    license = licenses.asl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    homepage = "https://jena.apache.org";
    downloadPage = "https://archive.apache.org/dist/jena/binaries/";
    mainProgram = "fuseki";
  };
}
