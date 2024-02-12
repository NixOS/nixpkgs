{ lib
, stdenv
, fetchurl
, java
, coreutils
, which
, makeWrapper
  # For the test
, pkgs
}:

stdenv.mkDerivation rec {
  pname = "apache-jena-fuseki";
  version = "4.9.0";
  src = fetchurl {
    url = "mirror://apache/jena/binaries/apache-jena-fuseki-${version}.tar.gz";
    hash = "sha256-t25Q0lb+ecR12cDD1p6eZnzLxW0kZpPOFGvo5YK7AlI=";
  };
  nativeBuildInputs = [
    makeWrapper
  ];
  installPhase = ''
    cp -r . "$out"
    chmod +x $out/fuseki
    ln -s "$out"/{fuseki-backup,fuseki-server,fuseki} "$out/bin"
    for i in "$out"/bin/*; do
      wrapProgram "$i" \
        --prefix "PATH" : "${java}/bin/:${coreutils}/bin:${which}/bin" \
        --set-default "FUSEKI_HOME" "$out" \
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
    homepage = "https://jena.apache.org";
    downloadPage = "https://archive.apache.org/dist/jena/binaries/";
  };
}
