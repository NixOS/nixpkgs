{ stdenv, fetchurl, xar, gzip, cpio }:

let
  pkg = { name, sha256 }: stdenv.mkDerivation {
    inherit name;

    src = fetchurl {
      # Magic url found in:
      # https://swscan.apple.com/content/catalogs/others/index-10.9-1.sucatalog
      url = "http://swcdn.apple.com/content/downloads/27/02/031-06182/yiervn212jfs091cp9hwmb7gjq7ky91crs/${name}.pkg";
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
    name   = "CLTools_Executables_OSX109";
    sha256 = "1cjdnnjny6h0dc1cc994pgrkmsa5cvk7pi5dpkxyslyicwf260fx";
  };

  sdk = pkg {
    name   = "DevSDK_OSX109";
    sha256 = "16b7aplha5573yl1d44nl2yxzp0w2hafihbyh7930wrcvba69iy4";
  };
}
