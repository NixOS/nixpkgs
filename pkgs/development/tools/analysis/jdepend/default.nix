{ lib
, stdenv
, fetchFromGitHub
, ant
, jdk
, makeWrapper
, canonicalize-jars-hook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jdepend";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "clarkware";
    repo = "jdepend";
    rev = finalAttrs.version;
    hash = "sha256-0/xGgAaJ7TTUHxShJbbcPzTODk4lDn+FOn5St5McrtM=";
  };

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
    canonicalize-jars-hook
  ];

  buildPhase = ''
    runHook preBuild
    ant jar
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/jdepend-*.jar -t $out/share/jdepend

    makeWrapper ${jdk.jre}/bin/java $out/bin/jdepend \
        --add-flags "-classpath $out/share/jdepend/jdepend-*.jar"

    for type in "swingui" "textui" "xmlui"; do
      makeWrapper $out/bin/jdepend $out/bin/jdepend-$type \
          --add-flags "jdepend.$type.JDepend"
    done

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/clarkware/jdepend/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Traverses Java class file directories and generates design quality metrics for each Java package";
    homepage = "http://www.clarkware.com/software/JDepend.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
})
