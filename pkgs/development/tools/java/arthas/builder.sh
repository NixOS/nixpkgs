
unset PATH

for p in $baseInputs $buildInputs; do
  if [ -d $p/bin ]; then
    export PATH="$p/bin${PATH:+:}$PATH"
  fi
  if [ -d $p/lib/pkgconfig ]; then
    export PKG_CONFIG_PATH="$p/lib/pkgconfig${PKG_CONFIG_PATH:+:}$PKG_CONFIG_PATH"
  fi
done

if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup

unpackPhase

mkdir -p $out/arthas


cp -r $src/* $out/arthas

export baseDir="$out/arthas"

makeWrapper $baseDir/as.sh $out/bin/as --set-default JAVA_HOME "$jdk"

makeWrapper $baseDir/as.sh $out/bin/arthas --set-default JAVA_HOME "$jdk"

runHook postInstall
