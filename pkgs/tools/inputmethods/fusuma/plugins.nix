{ lib, bundlerApp, bundlerUpdateScript, makeWrapper, fusuma, libinput }:
{
  appmatcher = bundlerApp {
    pname = "fusuma-plugin-appmatcher";
    gemdir = ./fusuma-plugin-appmatcher;
    exes = [ "fusuma-appmatcher" ];
    
    nativeBuildInputs = [ makeWrapper ];
    
    postBuild = ''
    wrapProgram "$out/bin/fusuma-appmatcher" \
      --prefix PATH : ${lib.makeBinPath [ libinput fusuma ]}
      '';
      
    passthru.updateScript = bundlerUpdateScript "fusuma-plugin-appmatcher";
    
    meta = with lib; {
      description = "Configure app-specific gestures plugin for Fusuma";
      homepage = "https://github.com/iberianpig/fusuma-plugin-appmatcher";
      license = licenses.mit;
      maintainers = with maintainers; [ lazygeniusman ];
      platforms = platforms.linux;
    };
  };

  keypress = bundlerApp {
    pname = "fusuma-plugin-keypress";
    gemdir = ./fusuma-plugin-keypress;
    exes = [ "fusuma-keypress" ];
                            
    passthru.updateScript = bundlerUpdateScript "fusuma-plugin-keypress";
    
    meta = with lib; {
      description = "Keypress combination plugin for Fusuma";
      homepage = "https://github.com/iberianpig/fusuma-plugin-keypress";
      license = licenses.mit;
      maintainers = with maintainers; [ lazygeniusman ];
      platforms = platforms.linux;
    };
  };

  sendkey = bundlerApp {
    pname = "fusuma-plugin-sendkey";
    gemdir = ./fusuma-plugin-sendkey;
    exes = [ "fusuma-sendkey" ];
    
    nativeBuildInputs = [ makeWrapper ];
    
    postBuild = ''
    wrapProgram "$out/bin/fusuma-sendkey" \
      --prefix PATH : ${lib.makeBinPath [ libinput fusuma ]}
    '';
    
    passthru.updateScript = bundlerUpdateScript "fusuma-plugin-sendkey";
    
    meta = with lib; {
      description = "Send virtual keyboard events plugin for Fusuma";
      homepage = "https://github.com/iberianpig/fusuma-plugin-sendkey";
      license = licenses.mit;
      maintainers = with maintainers; [ lazygeniusman ];
      platforms = platforms.linux;
    };
  };

  tap = bundlerApp {
    pname = "fusuma-plugin-tap";
    gemdir = ./fusuma-plugin-tap;
    exes = [ "fusuma-tap" ];
                                       
    passthru.updateScript = bundlerUpdateScript "fusuma-plugin-tap";
    
    meta = with lib; {
      description = "Recognize multitouch tap plugin for Fusuma";
      homepage = "https://github.com/iberianpig/fusuma-plugin-tap";
      license = licenses.mit;
      maintainers = with maintainers; [ lazygeniusman ];
      platforms = platforms.linux;
    };
  };
}
