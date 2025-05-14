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
    description = "A game that combines units from the official OpenRA Red Alert and Tiberian Dawn mods";
    homepage = "https://github.com/Inq8/CAmod";
    src = fetchFromGitHub {
      owner = "Inq8";
      repo = "CAmod";
      rev = "fc3cf0baf2b827650eaae9e1d2335a3eed24bac9";
      sha256 = "15w91xs253gyrlzsgid6ixxjazx0fbzick6vlkiay0znb58n883m";
    };
    engine = {
      version = "b8a7dd5";
      src = fetchFromGitHub {
        owner = "Inq8";
        repo = "CAengine";
        rev = "b8a7dd52ff893ed8225726d4ed4e14ecad748404";
        sha256 = "0dyk861qagibx8ldshz7d2nrki9q550f6f0wy8pvayvf1gv1dbxj";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  d2 = unsafeBuildOpenRAMod rec {
    version = "134.git.69a4aa7";
    title = "Dune II";
    description = "A modernization of the original ${title} game";
    homepage = "https://github.com/OpenRA/d2";
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "d2";
      rev = "69a4aa708e2c26376469c0048fac13592aa452ca";
      sha256 = "1mfch4s6c05slyqvxllklbxpqq8dqcbx3515n3gyylyq43gq481r";
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
        sha256 = "0p0izykjnz7pz02g2khp7msqa00jhjsrzk9y0g29dirmdv75qa4r";
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
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = "https://github.com/drogoganor/DarkReign";
    src = fetchFromGitHub {
      owner = "drogoganor";
      repo = "DarkReign";
      rev = "ffcd6ba72979e5f77508136ed7b0efc13e4b100e";
      sha256 = "07g4qw909649s3i1yhw75613mpwfka05jana5mpp5smhnf0pkack";
    };
    engine = {
      version = "DarkReign";
      src = fetchFromGitHub {
        owner = "drogoganor";
        repo = "OpenRA";
        rev = "f91d3f2603bbf51afaa89357e4defcdc36138102";
        sha256 = "05g900ri6q0zrkrk8rmjaz576vjggmi2y6jm0xz3cwli54prn11w";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  gen = buildOpenRAMod {
    version = "1157.git.4f5e11d";
    title = "Generals Alpha";
    description = "Re-imagination of the original Command & Conquer: Generals game";
    homepage = "https://github.com/MustaphaTR/Generals-Alpha";
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Generals-Alpha";
      rev = "4f5e11d916e4a03d8cf1c97eef484ce2d77d7df2";
      sha256 = "1wnl4qrlhynnlahgdlxwhgsdba5wgdg9yrv9f8hkgi69j60szypd";
    };
    engine = rec {
      version = "gen-20190128_3";
      src = fetchFromGitHub {
        owner = "MustaphaTR";
        repo = "OpenRA";
        rev = version;
        sha256 = "1x6byz37s8qcpqj902zvkvbv95rv2mv2kj35c12gbpyc92xkqkq0";
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
      description = "Re-imagination of the original ${title} game";
      homepage = "https://kknd-game.com/";
      src = fetchFromGitHub {
        owner = "IceReaper";
        repo = "KKnD";
        rev = "5530babcb05170e0959e4cf2b079161e9fedde4f";
        sha256 = "07jczrarmgm6zdk0myzwgq200x19yvpjyxrnhdac08mjgyz75zk1";
      };
      engine = {
        version = "4e8eab4ca00d1910203c8a103dfd2c002714daa8";
        src = fetchFromGitHub {
          owner = "IceReaper";
          repo = "OpenRA";
          # commit does not exist on any branch on the target repository
          rev = "4e8eab4ca00d1910203c8a103dfd2c002714daa8";
          sha256 = "1yyqparf93x8yzy1f46gsymgkj5jls25v2yc7ighr3f7mi3igdvq";
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
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = "https://github.com/CombinE88/Medieval-Warfare";
    src = fetchFromGitHub {
      owner = "CombinE88";
      repo = "Medieval-Warfare";
      rev = "c9be8f2a6f1dd710b1aedd9d5b00b4cf5020e2fe";
      sha256 = "09fp7k95jd6hjqdasbspbd43z5670wkyzbbgqkll9dfsrv0sky0v";
    };
    engine = {
      version = "MedievalWarfareEngine";
      src = fetchFromGitHub {
        owner = "CombinE88";
        repo = "OpenRA";
        rev = "52109c0910f479753704c46fb19e8afaab353c83";
        sha256 = "0ga3855j6bc7h81q03cw6laiaiz12915zg8aqah1idvxbzicfy7l";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  ra2 = buildOpenRAMod rec {
    version = "903.git.2f7c700";
    title = "Red Alert 2";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    homepage = "https://github.com/OpenRA/ra2";
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "ra2";
      rev = "2f7c700d6d63c0625e7158ef3098221fa6741569";
      sha256 = "11vnzwczn47wjfrq6y7z9q234p27ihdrcl5p87i6h2xnrpwi8b6m";
    };
    engine = rec {
      version = "release-20180923";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA";
        rev = version;
        sha256 = "1pgi3zaq9fwwdq6yh19bwxscslqgabjxkvl9bcn1a5agy4bfbqk5";
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
    description = "A modernization of the original Command & Conquer: Red Alert game";
    homepage = "https://github.com/OpenRA/raclassic";
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "raclassic";
      rev = "c76c13e9f0912a66ddebae8d05573632b19736b2";
      sha256 = "1cnr3ccvrkjlv8kkdcglcfh133yy0fkva9agwgvc7wlj9n5ydl4g";
    };
    engine = rec {
      version = "release-20190314";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA";
        rev = version;
        sha256 = "15pvn5cx3g0nzbrgpsfz8dngad5wkzp5dz25ydzn8bmxafiijvcr";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  rv = unsafeBuildOpenRAMod {
    version = "1330.git.9230e6f";
    title = "Romanov's Vengeance";
    description = "Re-imagination of the original Command & Conquer: Red Alert 2 game";
    homepage = "https://github.com/MustaphaTR/Romanovs-Vengeance";
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Romanovs-Vengeance";
      rev = "9230e6f1dd9758467832aee4eda115e18f0e635f";
      sha256 = "0bwbmmlhp1kh8rgk2nx1ca9vqssj849amndacf318d61gksc1w9n";
    };
    engine = {
      version = "f3873ae";
      mods = [ "as" ];
      src = fetchFromGitHub {
        owner = "AttacqueSuperior";
        repo = "Engine";
        rev = "f3873ae242803051285994d77eb26f4b951594b5";
        sha256 = "02rv29wja0p5d083pd087daz7x7pp5b9ym7sci2fhg3mrnaqgwkp";
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
    description = "Re-imagination of the original Command & Conquer: Tiberian Sun game";
    homepage = "https://github.com/ABrandau/OpenRAModSDK";
    src = fetchFromGitHub {
      owner = "ABrandau";
      repo = "OpenRAModSDK";
      rev = "ac000cc15377cdf6d3c2b72c737d692aa0ed8bcd";
      sha256 = "16mzs5wcxj9nlpcyx2c87idsqpbm40lx0rznsccclnlb3hiwqas9";
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
        sha256 = "1jvgpbf56hd02ikhklv49br4d1jiv5hphc5kl79qnjlaacnj222x";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  ss = buildOpenRAMod rec {
    version = "77.git.23e1f3e";
    title = "Sole Survivor";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = "https://github.com/MustaphaTR/sole-survivor";
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "sole-survivor";
      rev = "23e1f3e5d8b98c936797b6680d95d56a69a9e2ab";
      sha256 = "104clmxphchs7r8y7hpmw103bychayz80bqj98bp89i64nv9d89x";
    };
    engine = {
      version = "6de92de";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA";
        rev = "6de92de8d982094a766eab97a92225c240d85493";
        sha256 = "0ps9x379plrrj1hnj4fpr26lc46mzgxknv5imxi0bmrh5y4781ql";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  ura = buildOpenRAMod {
    version = "431.git.128dc53";
    title = "Red Alert Unplugged";
    description = "Re-imagination of the original Command & Conquer: Red Alert game";
    homepage = "http://redalertunplugged.com/";
    src = fetchFromGitHub {
      owner = "RAunplugged";
      repo = "uRA";
      rev = "128dc53741fae923f4af556f2293ceaa0cf571f0";
      sha256 = "1mhr8kyh313z52gdrqv31d6z7jvdldiajalca5mcr8gzg6mph66p";
    };
    engine = rec {
      version = "unplugged-cd82382";
      src = fetchFromGitHub {
        owner = "RAunplugged";
        repo = "OpenRA";
        rev = version;
        sha256 = "1p5hgxxvxlz8480vj0qkmnxjh7zj3hahk312m0zljxfdb40652w1";
        name = "engine";
        inherit postFetch;
      };
    };
  };

  yr = unsafeBuildOpenRAMod rec {
    version = "199.git.5b8b952";
    homepage = "https://github.com/cookgreen/yr";
    title = "Yuri's Revenge";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    src = fetchFromGitHub {
      owner = "cookgreen";
      repo = "yr";
      rev = "5b8b952dbe21f194a6d00485f20e215ce8362712";
      sha256 = "0hxzrqnz5d7qj1jjr20imiyih62x1cnmndf75nnil4c4sj82f9a6";
    };
    engine = rec {
      version = "release-20190314";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA";
        rev = version;
        sha256 = "15pvn5cx3g0nzbrgpsfz8dngad5wkzp5dz25ydzn8bmxafiijvcr";
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
