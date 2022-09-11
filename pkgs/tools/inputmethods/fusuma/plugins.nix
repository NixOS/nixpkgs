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
}
