source $stdenv/setup
source $makeWrapper

unpackPhase

mkdir -p $out
cp -r $name/* $out

# Make a backup of the original directory
cp -r $out/bin $out/bin-orig
# Remove the original mvn from the bin directory
rm $out/bin/$mavenBinary
# Set the JAVA_HOME variable when using Maven
makeWrapper "$out/bin-orig/$mavenBinary" "$out/bin/$mavenBinary"  --set JAVA_HOME "$jdk"
