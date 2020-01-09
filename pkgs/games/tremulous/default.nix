{ stdenv, fetchurl, unzip, libGLU, libGL, libX11, SDL, openal, runtimeShell }:
stdenv.mkDerivation rec {
  pname = "tremulous";
  version = "1.1.0";
  src1 = fetchurl {
    url = "mirror://sourceforge/tremulous/${pname}-${version}.zip";
    sha256 = "11w96y7ggm2sn5ncyaffsbg0vy9pblz2av71vqp9725wbbsndfy7";
  };
  # http://tremulous.net/wiki/Client_versions
  src2 = fetchurl {
    url = "http://releases.mercenariesguild.net/client/mgclient_source_Release_1.011.tar.gz";
    sha256 = "1vrsi7va7hdp8k824663s1pyw9zpsd4bwwr50j7i1nn72b0v9a26";
  };
  src3 = fetchurl {
    url = "http://releases.mercenariesguild.net/tremded/mg_tremded_source_1.01.tar.gz";
    sha256 = "1njrqlhzjvy9myddzkagszwdcf3m4h08wip888w2rmbshs6kz6ql";
  };
  buildInputs = [ unzip libGLU libGL libX11 SDL openal ];
  unpackPhase = ''
    unzip $src1
    cd tremulous
    tar xvf $src2
    mkdir mg_tremded_source
    cd mg_tremded_source
    tar xvf $src3
    cd ..
  '';
  patches = [ ./parse.patch ];
  patchFlags = [ "-p" "0" ];
  NIX_LD_FLAGS = ''
    -rpath ${stdenv.cc}/lib
    -rpath ${stdenv.cc}/lib64
  '';
  buildPhase = ''
    cd Release_1.011
    make
    cd ..
    cd mg_tremded_source
    make
    cd ..
  '';
  installPhase = ''
    arch=$(uname -m | sed -e s/i.86/x86/)
    mkdir -p $out/opt/tremulous
    cp -v Release_1.011/build/release-linux-$arch/tremulous.$arch $out/opt/tremulous/
    cp -v mg_tremded_source/build/release-linux-$arch/tremded.$arch $out/opt/tremulous/
    cp -rv base $out/opt/tremulous
    mkdir -p $out/bin
    for b in tremulous tremded
    do
        cat << EOF > $out/bin/$b
    #!${runtimeShell}
    cd $out/opt/tremulous
    exec ./$b.$arch "\$@"
    EOF
        chmod +x $out/bin/$b
    done
  '';
  dontPatchELF = true;
  meta = with stdenv.lib; {
    description = "A game that blends a team based FPS with elements of an RTS";
    longDescription = ''
      Tremulous is a free, open source game that blends a team based FPS with
      elements of an RTS. Players can choose from 2 unique races, aliens and
      humans. Players on both teams are able to build working structures
      in-game like an RTS. These structures provide many functions, the most
      important being spawning. The designated builders must ensure there are
      spawn structures or other players will not be able to rejoin the game
      after death. Other structures provide automated base defense (to some
      degree), healing functions and much more...
    '';
    homepage = http://www.tremulous.net;
    license = with licenses; [
      gpl2
      cc-by-sa-25 /* media */
    ];
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
    broken = true;
  };
}
