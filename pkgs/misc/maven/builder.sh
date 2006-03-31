source $stdenv/setup
source $makeWrapper

unpackPhase

mkdir -p $out
cp -r $name/* $out

# Make a backup of the original directory
cp -r $out/bin $out/bin-orig
# Remove the original mvn from the bin directory
rm $out/bin/mvn
# Set the JAVA_HOME variable when using `mvn'
makeWrapper "$out/bin-orig/mvn" "$out/bin/mvn"  --set JAVA_HOME "$jdk"
