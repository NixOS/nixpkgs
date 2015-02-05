{ stdenv, fetchurl, xar, gzip, cpio }:

let
  pkg = { name, sha256 }: stdenv.mkDerivation {
    inherit name;

    src = fetchurl {
      url = "http://swcdn.apple.com/content/downloads/00/14/031-07556/i7hoqm3awowxdy48l34uel4qvwhdq8lgam/${name}.pkg";
      inherit sha256;
    };

    buildInputs = [ xar gzip cpio ];

    phases = [ "unpackPhase" "installPhase" ];

    unpackPhase = ''
      xar -x -f $src
    '';

    installPhase = ''
      start="$(pwd)"
      mkdir -p $out
      cd $out
      cat $start/Payload | gzip -d | cpio -idm
    '';

    meta = with stdenv.lib; {
      description = "Apple developer tools ${name}";
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.darwin;
    };
  };
in rec {
  tools = pkg {
    name   = "CLTools_Executables";
    sha256 = "1rqrgip9pwr9d6p1hkd027lzxpymr1qm54jjnkldjjb8m4nps7bp";
  };

  sdk = pkg {
    name   = "DevSDK_OSX109";
    sha256 = "0x6r61h78r5cxk9dbw6fnjpn6ydi4kcajvllpczx3mi52crlkm4x";
  };
}
