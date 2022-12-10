{ lib, stdenv, fetchFromGitHub, runCommand
, jdk8, ant
, jre8, makeWrapper
}:

let
  gcs = fetchFromGitHub {
    owner = "richardwilkes";
    repo = "gcs";
    rev = "gcs-4.8.0";
    sha256 = "0k8am8vfwls5s2z4zj1p1aqy8gapn5vbr9zy66s5g048ch8ah1hm";
  };
  appleStubs = fetchFromGitHub {
    owner = "richardwilkes";
    repo = "apple_stubs";
    rev = "gcs-4.3.0";
    sha256 = "0m1qw30b19s04hj7nch1mbvv5s698g5dr1d1r7r07ykvk1yh7zsa";
  };
  toolkit = fetchFromGitHub {
    owner = "richardwilkes";
    repo = "toolkit";
    rev = "gcs-4.8.0";
    sha256 = "1ciwwh0wxk3pzsj6rbggsbg3l2f741qy7yx1ca4v7vflsma84f1n";
  };
  library = fetchFromGitHub {
    owner = "richardwilkes";
    repo = "gcs_library";
    rev = "gcs-4.8.0";
    sha256 = "085jpp9mpv5kw00zds9sywmfq31mrlbrgahnwcjkx0z9i22amz4g";
  };
in stdenv.mkDerivation rec {
  pname = "gcs";
  version = "4.8.0";

  src = runCommand "${pname}-${version}-src" { preferLocalBuild = true; } ''
    mkdir -p $out
    cd $out

    cp -r ${gcs} gcs
    cp -r ${appleStubs} apple_stubs
    cp -r ${toolkit} toolkit
    cp -r ${library} gcs_library
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk8 jre8 ant ];
  buildPhase = ''
    cd apple_stubs
    ant

    cd ../toolkit
    ant

    cd ../gcs
    ant

    cd ..
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/java

    find gcs/libraries toolkit/libraries apple_stubs/ \( -name '*.jar' -and -not -name '*-src.jar' \) -exec cp '{}' $out/share/java ';'

    makeWrapper ${jre8}/bin/java $out/bin/gcs \
      --set GCS_LIBRARY ${library} \
      --add-flags "-cp $out/share/java/gcs-${version}.jar com.trollworks.gcs.app.GCS"
  '';

  meta = with lib; {
    description = "A stand-alone, interactive, character sheet editor for the GURPS 4th Edition roleplaying game system";
    homepage = "https://gurpscharactersheet.com/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # source bundles dependencies as jars
    ];
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [];
  };
}
