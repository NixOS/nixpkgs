{ stdenv, fetchFromGitHub, qtbase, openscenegraph, mygui, bullet, ffmpeg, boost, cmake, SDL2, unshield, openal
, libXt, writeScriptBin, makeWrapper, symlinkJoin, ncurses, mesa_noglu, terra }:

let
  mygui_ = mygui.override {
    inherit stdenv;
  };
  terra_ = symlinkJoin {
    name = "terra";
    paths = [ terra.static terra.dev ];
  };
  TES3MP = fetchFromGitHub {
    owner = "TES3MP";
    repo = "openmw-tes3mp";
    rev = "f61664ff6d521e10db761a550c97c6edce8f0046";
    sha256 = "12h01kafyzq0h1cgf1c8d4mlvlplg5lvcnsc5m5h602r763pzgbb";
  };
  CallFF = fetchFromGitHub {
    owner = "Koncord";
    repo = "CallFF";
    rev = "4aa5a31b7543a8f784852a5a109202b2783e93d9";
    sha256 = "0cf7r8hfh79bsg4p4k1iwhxapyakkvi0hcwwvzg1ln0fqm2yqp57";
  };
  RakNet = fetchFromGitHub {
    owner = "TES3MP";
    repo = "RakNet";
    rev = "9ace90a385f60e0b919bd84964a53fb1d42438ba";
    sha256 = "0mkf5wx23w20fw9cmbiyfs86gmf0r11pdpd8y7qd4k4wl9c7n45q";
  };
  PluginExamples = fetchFromGitHub {
    owner = "TES3MP";
    repo = "PluginExamples";
    rev = "213e72f315a8029eec71437e56de0eaeba5b3670";
    sha256 = "1q0cvz1s0zyq982066wgplnylqbiszz0bmcv2prqv78vq9is1l6b";
  };

  fakegit = writeScriptBin "git" ''
    #! ${stdenv.shell}
    if [ "$*" = "rev-list --tags --max-count=1" ] ||
       [ "$*" = "rev-parse HEAD" ]; then
      echo "${TES3MP.rev}"
    else
      exit 1
    fi
  '';
in stdenv.mkDerivation rec {
  version = "0.6.0";
  name = "tes3mp-${version}";

  src = fetchFromGitHub {
    owner = "GrimKriegor";
    repo = "TES3MP-deploy";
    rev = "ac2e862c3b96206d8e0678d422ece30f9f2d0f45";
    sha256 = "0nysr6h7sa1j5ijyd52k6sw052vcdqdx4wjjmmy7p8wh1i0jkvv6";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [ cmake makeWrapper fakegit ];
  buildInputs = [ boost ffmpeg qtbase bullet mygui_ openscenegraph SDL2 unshield openal libXt
    ncurses mesa_noglu ];

  buildPhase = ''
    mkdir dependencies keepers
    cp --no-preserve=mode -r ${TES3MP} code
    mkdir code/.git
    cp --no-preserve=mode -r ${CallFF} dependencies/callff
    cp --no-preserve=mode -r ${RakNet} dependencies/raknet
    cp --no-preserve=mode -r ${PluginExamples} keepers/PluginExamples
    ln -s ${terra_} dependencies/terra

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
      --run "[ -d PluginExamples ] || cp --no-preserve=mode -r $prefix/keepers/PluginExamples ." \
      --run "[ -f tes3mp-server.cfg ] || echo \"[Plugins] home = \$HOME/.config/openmw/PluginExamples\" > tes3mp-server.cfg"
  '';

  meta = with stdenv.lib; {
    description = "Multiplayer for TES3:Morrowind based on OpenMW";
    homepage = "https://tes3mp.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
