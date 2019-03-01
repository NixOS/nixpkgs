{ stdenv, lib, file, fetchurl, makeWrapper,
  autoPatchelfHook, jsoncpp, libpulseaudio }:
let
  versionMajor = "6.5";
  versionMinor = "6";
  versionBuild_x86_64 = "9";
  versionBuild_i686 = "8";
in
  stdenv.mkDerivation rec {
    pname = "nomachine-client";
    version = "${versionMajor}.${versionMinor}";
  
    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://download.nomachine.com/download/${versionMajor}/Linux/nomachine_${version}_${versionBuild_x86_64}_x86_64.tar.gz";
          sha256 = "07lg5yadxpl5qfvvh067b3kxd8hm3xv95ralm2pyjl4lw6aql46p";
        }
      else if stdenv.hostPlatform.system == "i686-linux" then
        fetchurl {
          url = "https://download.nomachine.com/download/${versionMajor}/Linux/nomachine_${version}_${versionBuild_i686}_i686.tar.gz";
          sha256 = "1a23isw09vicazkrypq0kxbb8qy2i4vxiarrgz5xmasjhiy5999a";
        }
      else
        throw "NoMachine client is not supported on ${stdenv.hostPlatform.system}";
    
    postUnpack = ''
      mv $(find . -type f -name nxclient.tar.gz) .
      mv $(find . -type f -name nxplayer.tar.gz) .
      rm -r NX/
      tar xf nxclient.tar.gz
      tar xf nxplayer.tar.gz
      rm $(find . -maxdepth 1 -type f)
    '';
  
    nativeBuildInputs = [ file makeWrapper autoPatchelfHook ];
    buildInputs = [ jsoncpp libpulseaudio ];

    installPhase = ''
      rm bin/nxplayer bin/nxclient

      mkdir -p $out/NX
      cp -r bin lib share $out/NX/

      ln -s $out/NX/bin $out/bin

      for i in share/icons/*; do
        if [[ -d "$i" ]]; then
          mkdir -p "$out/share/icons/hicolor/$(basename $i)/apps"
          cp "$i"/* "$out/share/icons/hicolor/$(basename $i)/apps/"
        fi
      done
  
      mkdir $out/share/applications
      cp share/applnk/player/xdg/*.desktop $out/share/applications/
      cp share/applnk/client/xdg-mime/*.desktop $out/share/applications/

      mkdir -p $out/share/mime/packages
      cp share/applnk/client/xdg-mime/*.xml $out/share/mime/packages/

      for i in $out/share/applications/*.desktop; do
        substituteInPlace "$i" --replace /usr/NX/bin $out/bin
      done
    '';
  
    postFixup = ''
      makeWrapper $out/bin/nxplayer.bin $out/bin/nxplayer --set NX_SYSTEM $out/NX
      makeWrapper $out/bin/nxclient.bin $out/bin/nxclient --set NX_SYSTEM $out/NX

      # libnxcau.so needs libpulse.so.0 for audio to work, but doesn't
      # have a DT_NEEDED entry for it.
      patchelf --add-needed libpulse.so.0 $out/NX/lib/libnxcau.so
    '';
  
    dontBuild = true;
    dontStrip = true;

    meta = with stdenv.lib; {
      description = "NoMachine remote desktop client (nxplayer)";
      homepage = https://www.nomachine.com/;
      license = {
        fullName = "NoMachine 6 End-User License Agreement";
        url = https://www.nomachine.com/licensing-6;
        free = false;
      };
      maintainers = with maintainers; [ talyz ];
      platforms = [ "x86_64-linux" "i686-linux" ];
    };
  }
  
