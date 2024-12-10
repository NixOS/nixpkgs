{
  lib,
  stdenv,
  fetchsvn,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "welkin";
  version = "1.1";

  src = fetchsvn {
    url = "http://simile.mit.edu/repository/welkin";
    rev = "9638";
    sha256 = "1bqh3vam7y805xrmdw7k0ckcfwjg88wypxgv3njkkwyn7kxnfnqp";
  };

  sourceRoot = "${src.name}/tags/${version}";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp -R . $out/share
    cp $out/share/welkin.sh $out/bin/welkin
    sed -e 's@\./lib/welkin\.jar@'"$out"'/share/lib/welkin.jar@' -i $out/bin/welkin
    wrapProgram $out/bin/welkin \
      --set JAVA_HOME ${jre}
    chmod a+x $out/bin/welkin
  '';

  meta = {
    description = "An RDF visualizer";
    maintainers = with lib.maintainers; [
      raskin
    ];
    hydraPlatforms = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; unix;
  };
}
