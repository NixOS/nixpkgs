{ stdenv, fetchurl, autoPatchelfHook, system, lib
# Used by the ASCII build.
, ncurses5
# Used by the graphical build only.
, SDL2, SDL2_image, SDL2_net, SDL2_mixer, SDL2_ttf
, luajit
}:

let
  version = "3.3.3";
  sources = {
    ascii = {
      x86_64-linux = fetchurl {
        url = "https://www.adom.de/home/download/current/adom_linux_ubuntu_64_${version}.tar.gz";
        sha256 = "493ef76594c1f6a7f38dcf32a76cd107fb71dd12bf917c18fdeaebcac1a353b1";
      };
      i686-linux = fetchurl {
        url = "https://www.adom.de/home/download/current/adom_linux_ubuntu_32_${version}.tar.gz";
        sha256 = "0fayy4vz4zk45i77j5nb1jx7rkl65jyfdp2wy0y9sv9p980yz0q3";
      };
    };
    graphical = {
      x86_64-linux = fetchurl {
        url = "https://www.indiedb.com/downloads/mirror/173928/115/4eb8407f7ab0e4143212c289acfbe735/";
        sha256 = "047q472rrr2xwkq76431i4acbfic1q9d01x45y49bbp58fsgvkgd";
      };
      i686-linux = fetchurl {
        url = "https://www.indiedb.com/downloads/mirror/173927/100/af42faf2994ef88e844fb630894f80c8";
        sha256 = "08dn1504qjwznwmzh4304igbv8fx9azw8rq70724pv9if72yja77";
      };
    };
  };

  mkAdom = type: stdenv.mkDerivation {
    name = "adom-${type}-${version}";

    src = sources.${type}.${system};

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [ ncurses5 ] ++ lib.optional (type == "graphical") [ 
      SDL2 SDL2_image SDL2_net SDL2_mixer SDL2_ttf
      luajit
    ];

    unpackPhase = ''
      tar xzf $src
      cd adom
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/adom $out/bin
      cp -a * $out/share/adom

      # Graphical build only.
      if [[ -d lib ]]; then
        rm $out/share/adom/lib/*
        cp lib/{libstdc++,libnoteye}* $out/share/adom/lib/
        addAutoPatchelfSearchPath $out/share/adom/lib
      fi

      cat >$out/bin/adom <<EOF
      #! ${stdenv.shell}
      cd $out/share/adom; exec adom
      EOF
      chmod +x $out/bin/adom
      runHook postInstall
    '';

    meta = with stdenv.lib; {
      description = "A rogue-like game with nice graphical interface";
      homepage = http://adom.de/;
      license = licenses.unfreeRedistributable;
      maintainers = [maintainers.Baughn];

      platforms = platforms.linux;
    };
  };
in {
  adom-ascii = mkAdom "ascii";
  adom-graphical = mkAdom "graphical";
}
