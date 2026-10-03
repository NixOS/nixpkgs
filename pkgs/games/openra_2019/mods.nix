{
  buildOpenRAMod,
  fetchFromGitHub,
  postFetch,
}:

let
  unsafeBuildOpenRAMod =
    attrs: name:
    (buildOpenRAMod attrs name).overrideAttrs (_: {
      doCheck = false;
    });

in
{
  ca = buildOpenRAMod {
    version = "96.git.fc3cf0b";
    title = "Combined Arms";
    meta.description = "A game that combines units from the official OpenRA Red Alert and Tiberian Dawn mods";
    meta.homepage = "https://github.com/Inq8/CAmod";
    src = fetchFromGitHub {
      owner = "Inq8";
      repo = "CAmod";
      rev = "fc3cf0baf2b827650eaae9e1d2335a3eed24bac9";
      hash = "sha256-dSBkUVn2A6/ipNtMFv9yoH8le4+mxac/zf6NInQPiZc=";
    };
    engine = {
      version = "b8a7dd5";
      src = fetchFromGitHub {
        owner = "Inq8";
        repo = "CAengine";
        rev = "b8a7dd52ff893ed8225726d4ed4e14ecad748404";
        hash = "sha256-sq8W9gtue7Uv8hw440ApOMWZrWjnQ90o6is+hYNB0zc=";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  d2 = unsafeBuildOpenRAMod rec {
    version = "134.git.69a4aa7";
    title = "Dune II";
    meta.description = "A modernization of the original ${title} game";
    meta.homepage = "https://github.com/OpenRA/d2";
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "d2";
      rev = "69a4aa708e2c26376469c0048fac13592aa452ca";
      hash = "sha256-OSCC3yDYU+/fsCWU0RfDDWF8+6KT0r6xp7oAZjSBzNU=";
    };
    engine = rec {
      version = "release-20181215";
      mods = [
        "cnc"
        "d2k"
        "ra"
      ];
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA";
        rev = version;
        hash = "sha256-mShczm41x5bEAz7Nn7WEEgCFdT0XTvEE+Pd8K6f/EVw=";
        name = "engine";
        inherit postFetch;
      };
    };
    assetsError = ''
      The mod expects the original ${title} game assets in place:
      https://github.com/OpenRA/d2/wiki
    '';
  };

  dr = buildOpenRAMod rec {
    version = "324.git.ffcd6ba";
    title = "Dark Reign";
    meta.description = "A re-imagination of the original Command & Conquer: ${title} game";
    meta.homepage = "https://github.com/drogoganor/DarkReign";
    src = fetchFromGitHub {
      owner = "drogoganor";
      repo = "DarkReign";
      rev = "ffcd6ba72979e5f77508136ed7b0efc13e4b100e";
      hash = "sha256-k6l5gbOw6nJvLcoqWYCajt86gimHQx/i0ImYBBLH5B0=";
    };
    engine = {
      version = "DarkReign";
      src = fetchFromGitHub {
        owner = "drogoganor";
        repo = "OpenRA";
        rev = "f91d3f2603bbf51afaa89357e4defcdc36138102";
        hash = "sha256-PASbLymRcjZ+B1UaL2J9T25zyleyZjTzzB9gEzMA6RU=";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  gen = buildOpenRAMod {
    version = "1157.git.4f5e11d";
    title = "Generals Alpha";
    meta.description = "Re-imagination of the original Command & Conquer: Generals game";
    meta.homepage = "https://github.com/MustaphaTR/Generals-Alpha";
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Generals-Alpha";
      rev = "4f5e11d916e4a03d8cf1c97eef484ce2d77d7df2";
      hash = "sha256-7fqvgZHJxDchcmlnn157vKjV9IO80/agotZ6SDMm1PI=";
    };
    engine = rec {
      version = "gen-20190128_3";
      src = fetchFromGitHub {
        owner = "MustaphaTR";
        repo = "OpenRA";
        rev = version;
        hash = "sha256-AE88u0jM3/VEYGXIKXYVO5e01577C5Akvgwjfcb3y/Q=";
        name = "generals-alpha-engine";
        inherit postFetch;
      };
    };
  };

  kknd =
    let
      version = "145.git.5530bab";
    in
    name:
    (buildOpenRAMod rec {
      inherit version;
      title = "Krush, Kill 'n' Destroy";
      meta.description = "Re-imagination of the original ${title} game";
      meta.homepage = "https://kknd-game.com/";
      src = fetchFromGitHub {
        owner = "IceReaper";
        repo = "KKnD";
        rev = "5530babcb05170e0959e4cf2b079161e9fedde4f";
        hash = "sha256-Yf5yvn+yIsBUgzZ3L+/2KXQABH78+wpm+6a+mlX+TB4=";
      };
      engine = {
        version = "4e8eab4ca00d1910203c8a103dfd2c002714daa8";
        src = fetchFromGitHub {
          owner = "IceReaper";
          repo = "OpenRA";
          # commit does not exist on any branch on the target repository
          rev = "4e8eab4ca00d1910203c8a103dfd2c002714daa8";
          hash = "sha256-eLcXR6zHjQxfPMyLXYSmssj5qtfPEBf896iP5LK62Ps=";
          name = "engine";
          inherit postFetch;
        };
      };
    } name).overrideAttrs
      (origAttrs: {
        postPatch = ''
          ${origAttrs.postPatch}
          sed -i 's/{DEV_VERSION}/${version}/' mods/*/mod.yaml
        '';
      });

  mw = buildOpenRAMod rec {
    version = "257.git.c9be8f2";
    title = "Medieval Warfare";
    meta.description = "A re-imagination of the original Command & Conquer: ${title} game";
    meta.homepage = "https://github.com/CombinE88/Medieval-Warfare";
    src = fetchFromGitHub {
      owner = "CombinE88";
      repo = "Medieval-Warfare";
      rev = "c9be8f2a6f1dd710b1aedd9d5b00b4cf5020e2fe";
      hash = "sha256-G/ipwc7atUTpxG+t7ycHx5Q/SFtXL60altA0WdI81yU=";
    };
    engine = {
      version = "MedievalWarfareEngine";
      src = fetchFromGitHub {
        owner = "CombinE88";
        repo = "OpenRA";
        rev = "52109c0910f479753704c46fb19e8afaab353c83";
        hash = "sha256-9HjH4l99txigwgq9X0IS4UcVFTWcDYADgoctI0tBQz0=";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  ra2 = buildOpenRAMod rec {
    version = "903.git.2f7c700";
    title = "Red Alert 2";
    meta.description = "Re-imagination of the original Command & Conquer: ${title} game";
    meta.homepage = "https://github.com/OpenRA/ra2";
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "ra2";
      rev = "2f7c700d6d63c0625e7158ef3098221fa6741569";
      hash = "sha256-1SwU+c22C2jiQbdQlhuMR1wyBE7/eIOzk/wQ+xn/doc=";
    };
    engine = rec {
      version = "release-20180923";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA";
        rev = version;
        hash = "sha256-ZeLlFvFPFRUsW4nu2eVSD1PNdOcrBegNbpy7hNUf8d0=";
        name = "engine";
        inherit postFetch;
      };
    };
    assetsError = ''
      The mod expects the original ${title} game assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };

  raclassic = buildOpenRAMod {
    version = "183.git.c76c13e";
    title = "Red Alert Classic";
    meta.description = "A modernization of the original Command & Conquer: Red Alert game";
    meta.homepage = "https://github.com/OpenRA/raclassic";
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "raclassic";
      rev = "c76c13e9f0912a66ddebae8d05573632b19736b2";
      hash = "sha256-j9Dmi02S8sP2408ltacD3o8RoGP0sTYn2lTOvBkb2bI=";
    };
    engine = rec {
      version = "release-20190314";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA";
        rev = version;
        hash = "sha256-mW0Zo1O9LmR/80X8Vu6fvDT1bEPf6fvy+ha80Vmx+5Y=";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  rv = unsafeBuildOpenRAMod {
    version = "1330.git.9230e6f";
    title = "Romanov's Vengeance";
    meta.description = "Re-imagination of the original Command & Conquer: Red Alert 2 game";
    meta.homepage = "https://github.com/MustaphaTR/Romanovs-Vengeance";
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Romanovs-Vengeance";
      rev = "9230e6f1dd9758467832aee4eda115e18f0e635f";
      hash = "sha256-NvHA9HzBNBSGY6rZqhJBUmu8k2KhWzFfRnCGC2mtiy8=";
    };
    engine = {
      version = "f3873ae";
      mods = [ "as" ];
      src = fetchFromGitHub {
        owner = "AttacqueSuperior";
        repo = "Engine";
        rev = "f3873ae242803051285994d77eb26f4b951594b5";
        hash = "sha256-d/KHlc11POhEZPpUn1a59/TzVTsItDsQaOUCJXkSOws=";
        name = "engine";
        inherit postFetch;
      };
    };
    assetsError = ''
      The mod expects the Command & Conquer: The Ultimate Collection assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };

  sp = unsafeBuildOpenRAMod {
    version = "221.git.ac000cc";
    title = "Shattered Paradise";
    meta.description = "Re-imagination of the original Command & Conquer: Tiberian Sun game";
    meta.homepage = "https://github.com/ABrandau/OpenRAModSDK";
    src = fetchFromGitHub {
      owner = "ABrandau";
      repo = "OpenRAModSDK";
      rev = "ac000cc15377cdf6d3c2b72c737d692aa0ed8bcd";
      hash = "sha256-SSvMIxyLWsoY0/Zn0CkgdV2sWzyIie7ZpTbJznjRv5o=";
    };
    engine = {
      version = "SP-22-04-19";
      mods = [
        "as"
        "ts"
      ];
      src = fetchFromGitHub {
        owner = "ABrandau";
        repo = "OpenRA";
        rev = "bb0930008a57c07f3002421023f6b446e3e3af69";
        hash = "sha256-XQghLVOKSovTobMweGHZUYZG8kpk0wlnFKBBU9y6b8s=";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  ss = buildOpenRAMod rec {
    version = "77.git.23e1f3e";
    title = "Sole Survivor";
    meta.description = "A re-imagination of the original Command & Conquer: ${title} game";
    meta.homepage = "https://github.com/MustaphaTR/sole-survivor";
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "sole-survivor";
      rev = "23e1f3e5d8b98c936797b6680d95d56a69a9e2ab";
      hash = "sha256-PaGWtiUmJnQXShIvgL5XkPk1QOD1wuNRPhoyeHuljIA=";
    };
    engine = {
      version = "6de92de";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA";
        rev = "6de92de8d982094a766eab97a92225c240d85493";
        hash = "sha256-FAd0iC8w1wVir7FsO/v71RBGjcjXEWlhkDnTm87oSV8=";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  ura = buildOpenRAMod {
    version = "431.git.128dc53";
    title = "Red Alert Unplugged";
    meta.description = "Re-imagination of the original Command & Conquer: Red Alert game";
    meta.homepage = "http://redalertunplugged.com/";
    src = fetchFromGitHub {
      owner = "RAunplugged";
      repo = "uRA";
      rev = "128dc53741fae923f4af556f2293ceaa0cf571f0";
      hash = "sha256-1xh4q3n/ocxqUYwqqWKjbcvzTQtj49yeKH+EAf1EGdY=";
    };
    engine = rec {
      version = "unplugged-cd82382";
      src = fetchFromGitHub {
        owner = "RAunplugged";
        repo = "OpenRA";
        rev = version;
        hash = "sha256-gYtiAFnNdUk/qCKMCRUc8h8ou60TA7kBIujTvnt/sNw=";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  yr = unsafeBuildOpenRAMod rec {
    version = "199.git.5b8b952";
    title = "Yuri's Revenge";
    meta.description = "Re-imagination of the original Command & Conquer: ${title} game";
    meta.homepage = "https://github.com/cookgreen/yr";
    src = fetchFromGitHub {
      owner = "cookgreen";
      repo = "yr";
      rev = "5b8b952dbe21f194a6d00485f20e215ce8362712";
      hash = "sha256-RiUnkNSEERqtLcc1Wy0LXRgYfawRiCxlkPi08i3Ov0M=";
    };
    engine = rec {
      version = "release-20190314";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA";
        rev = version;
        hash = "sha256-mW0Zo1O9LmR/80X8Vu6fvDT1bEPf6fvy+ha80Vmx+5Y=";
        name = "engine";
        inherit postFetch;
      };
    };
    assetsError = ''
      The mod expects the Command & Conquer: The Ultimate Collection assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };
}
