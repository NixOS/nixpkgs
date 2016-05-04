{ stdenv }:

let
  version = "10.9";
in stdenv.mkDerivation rec {
  name = "MacOSX10.9.sdk";

  src = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk";

  unpackPhase = "true";
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/Developer/SDKs/
    echo "Source is: $src"
    cp -r $src $out/Developer/SDKs/
  '';

  meta = with stdenv.lib; {
    description = "The Mac OS ${version} SDK";
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.unfree;
  };
}
