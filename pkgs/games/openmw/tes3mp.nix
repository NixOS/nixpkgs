{ stdenv, fetchFromGitHub, qtbase, openscenegraph, mygui, bullet, ffmpeg, boost, cmake, SDL2, unshield, openal
, libXt, writeScriptBin, makeWrapper, ncurses, libGL, luajit }:

let
  version = "0.7.0-alpha";
  TES3MP = fetchFromGitHub {
    owner = "TES3MP";
    repo = "openmw-tes3mp";
    rev = version;
    sha256 = "012f50f9jd29qcdww2vk4habg6pmxvxl0q6rrjq8xchb0566712q";
  };
  CallFF = fetchFromGitHub {
    owner = "Koncord";
    repo = "CallFF";
    rev = "da94b59ffe95d45bf98b9264e3d1279c9f6ebb6b";
    sha256 = "10wgiqmknh0av968c6r74n5n2izxsx8qawfrab57kkmj9h0zp0pm";
  };
  CrabNet = fetchFromGitHub {
    owner = "TES3MP";
    repo = "CrabNet";
    rev = "ab1306050fe0f5b0f9c4f56893a79e56a9459567";
    sha256 = "03q76pjv9mdi7w832b23q1mj4r2wb0hsnh4kpvwai607g04l0pp0";
  };
  CoreScripts = fetchFromGitHub {
    owner = "TES3MP";
    repo = "CoreScripts";
    rev = "1e9f69f98051b2639b18203f989ffbd0a4b427ea";
    sha256 = "03ysi7rh0k78kv4slvmkxpymxvdpr8b6hwr1lvjdgq7rq0ljy0lg";
  };

  fakegit = writeScriptBin "git" ''
    #! ${stdenv.shell}
  '';
in stdenv.mkDerivation rec {
  inherit version;
  name = "tes3mp-${version}";

  src = fetchFromGitHub {
    owner = "GrimKriegor";
    repo = "TES3MP-deploy";
    rev = "1dd78a3e2cf9f4fe85bf7ca9c393251968a9c325";
    sha256 = "1bp9c4kds9q0xhbn4sxb7n0f6rvb45gzx7ljdgc56wz4j5rfi3xn";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [ cmake makeWrapper fakegit ];
  buildInputs = [ boost ffmpeg qtbase bullet mygui openscenegraph SDL2 unshield openal libXt
    ncurses libGL luajit ];

  buildPhase = ''
    mkdir dependencies keepers
    cp --no-preserve=mode -r ${TES3MP} code
    cp --no-preserve=mode -r ${CallFF} dependencies/callff
    cp --no-preserve=mode -r ${CrabNet} dependencies/raknet
    cp --no-preserve=mode -r ${CoreScripts} keepers/CoreScripts

    substituteInPlace tes3mp-deploy.sh \
      --replace "-DBUILD_OPENCS=OFF" "-DBUILD_OPENCS=OFF -DCMAKE_INSTALL_PREFIX=$out"
    patchShebangs tes3mp-deploy.sh
    echo y | ./tes3mp-deploy.sh -i -c $NIX_BUILD_CORES
  '';

  installPhase = ''
    prefix=$out/opt/tes3mp
    mkdir -p $prefix/build $out/etc/openmw $out/bin
    for i in build/*; do
      if [ -f "$i" ] && [ -x "$i" ]; then
        mv "$i" $prefix/build
      fi
    done
    mv build/resources $prefix/build
    mv build/{settings-default.cfg,openmw.cfg,gamecontrollerdb.txt} $out/etc/openmw
    mv keepers $prefix
    mv build/tes3mp-credits.md $prefix/build
    mv -f $prefix/keepers/version $prefix/build/resources

    for i in tes3mp.sh tes3mp-browser.sh tes3mp-server.sh
    do
      bin="$out/bin/''${i%.sh}"
      mv $i $bin
      substituteInPlace $bin \
        --replace build/ $prefix/build/
      chmod +x $bin
    done
    ln -s $prefix/keepers/*.cfg $out/etc/openmw/

    wrapProgram $out/bin/tes3mp-server \
      --run "mkdir -p ~/.config/openmw" \
      --run "cd ~/.config/openmw" \
      --run "[ -d CoreScripts ] || cp --no-preserve=mode -r $prefix/keepers/CoreScripts ." \
      --run "[ -f tes3mp-server.cfg ] || echo \"[Plugins] home = \$HOME/.config/openmw/CoreScripts\" > tes3mp-server.cfg"
  '';

  meta = with stdenv.lib; {
    description = "Multiplayer for TES3:Morrowind based on OpenMW";
    homepage = "https://tes3mp.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
