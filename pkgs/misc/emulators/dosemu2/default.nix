{ stdenv, fetchFromGitHub, fetchurl,
bison, flex, SDL2, udev, libslirp, json_c, autoconf, automake,
pkg-config, libbsd, hexdump, slang, xorg, readline, libao,
gpm, munt, libieee1284 }:
stdenv.mkDerivation {
  name = "dosemu2";
  srcs = [
    (fetchFromGitHub {
      owner = "dosemu2";
      repo = "dosemu2";
      rev = "7d2ee11c2111394b73a6b18b5b9404474f000ef6";
      sha256 = "1sapq4mhzj6frpn95fs1ndi0za4w7spidl2y9p27pshpfs2xc4im";
    })
    (fetchurl {
      url = "mirror://sourceforge/dosemu/dosemu-freedos-1.0-bin.tgz";
      sha256 = "1izbq2lvbbggay52n21qpz949sv8y9i60ik4zmhih7k13dm30308";
    })
  ];

  buildInputs = [
    bison flex SDL2 udev libslirp json_c
    autoconf automake pkg-config libbsd hexdump
    slang xorg.mkfontdir readline libao gpm munt
    libieee1284
  ];

  configureFlags = [
    "--disable-fdpp"
    "--with-fdtarball=dosemu-freedos-1.0-bin.tgz"
  ];

  unpackPhase = ''
    runHook preUnpack

    read -a arr <<< "$srcs"
    dosemu2="''${arr[0]}"
    freedostar="''${arr[1]}"
    unpackFile "$dosemu2"
    sourceRoot="source"

    if [ "${dontMakeSourcesWritable:-0}" != 1 ]; then
      chmod -R u+w -- "$sourceRoot"
    fi

    cp "$freedostar" "$sourceRoot/$(stripHash $freedostar)"

    runHook postUnpack
  '';

  postUnpack = ''
        sed -i -e "s|DATE=.*|DATE='Mon, 2 Nov 2020 15:49:15 +0300'|" "$sourceRoot/git-rev.sh"
        sed -i -e "s:^}$:  prefix $prefix\n&:g" "$sourceRoot/compiletime-settings"
  '';

  preConfigure = ''
        ./autogen.sh
  '';

  installPhase = ''
        if [ -n "$prefix" ]; then
          mkdir -p "$prefix";
        fi;
        make SHELL="$(which bash)" PREFIX="$prefix" install

  '';

  meta = with stdenv.lib; {
    description = "DOS emulator for linux";
    homepage = "http://dosemu2.github.io/dosemu2/";
    license = licenses.gpl2Only;
    maintainers = [ "Jaume Delclòs Coll <jaume@delclos.com>" ];
  };
}
