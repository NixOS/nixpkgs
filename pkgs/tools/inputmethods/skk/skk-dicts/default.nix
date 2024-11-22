{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
, nkf
, skktools
, useUtf8 ? false
}:

let
  suffix = lib.optionalString useUtf8 ".utf8";

  mkDictNameValue =
    { name
    , description
    , license # it's written in the beginning of each file
    , files ? [ "SKK-JISYO.${name}" ]
    }: {
      name = lib.toLower (builtins.replaceStrings [ "." ] [ "_" ] name);
      value = stdenvNoCC.mkDerivation {
        pname = "skk-jisyo-" + lib.toLower name;
        version = "0-unstable-2024-08-28";

        src = fetchFromGitHub {
          owner = "skk-dev";
          repo = "dict";
          rev = "4eb91a3bbfef70bde940668ec60f3beae291e971";
          sha256 = "sha256-sWz85Q6Bu2WoKsckSp5SlcuPUQN2mcq+BHMqNXQ/aho=";
        };

        nativeBuildInputs = lib.optionals useUtf8 [ nkf ];

        strictDeps = true;

        buildPhase = ''
          runHook preBuild
        '' + lib.concatMapStrings
          (file: ''
            nkf -w ${file} \
              | LC_ALL=C sed 's/coding: [^ ]\{1,\}/coding: utf-8/' \
              > ${file + suffix}
          '')
          (lib.optionals useUtf8 (map lib.escapeShellArg files)) + ''
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
        '' + lib.concatMapStrings
          (file: ''
            install -Dm644 \
              ${lib.escapeShellArg file} \
              $out/share/skk/${lib.escapeShellArg (baseNameOf file)}
          '')
          (map (file: file + suffix) files) + ''
          runHook postInstall
        '';

        doInstallCheck = true;
        installCheckPhase = ''
          emptydict=': 0 candidates$'
          ${skktools}/bin/skkdic-count /dev/null | grep "$emptydict"
          ${skktools}/bin/skkdic-count $out/share/skk/* | grep -v "$emptydict"
        '';

        passthru.updateScript = nix-update-script {
          extraArgs = ["--version" "branch"];
        };

        meta = with lib; {
          inherit description license;
          longDescription = ''
            This package provides a kana-to-kanji conversion dictionary for the
            SKK Japanese input method.
          '';
          homepage = "https://github.com/skk-dev/dict";
          maintainers = with maintainers; [ yuriaisaka midchildan ];
          platforms = platforms.all;
        };
      };
    };
in
lib.listToAttrs (map mkDictNameValue [
  {
    name = "L";
    description = "The standard SKK dictionary";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "S";
    description = "Small SKK dictionary";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "M";
    description = "Medium sized SKK dictionary";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "ML";
    description = "Medium to large sized SKK dictionary";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "jinmei";
    description = "SKK dictionary for names";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "fullname";
    description = "SKK dictionary for celebrities";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "geo";
    description = "SKK dictionary for locations";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "propernoun";
    description = "SKK dictionary for proper nouns";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "station";
    description = "SKK dictionary for stations";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "law";
    description = "SKK dictionary for legal terms";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "okinawa";
    description = "SKK dictionary for the Okinawan language";
    license = lib.licenses.publicDomain;
  }
  {
    name = "china_taiwan";
    description = "SKK dictionary for Chinese & Taiwanese locations";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "assoc";
    description = "SKK dictionary for abbreviated input";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "edict";
    description = "SKK dictionary for English to Japanese translation";
    license = lib.licenses.cc-by-sa-30;
  }
  {
    name = "zipcode";
    description = "SKK dictionary for Japanese zipcodes";
    files = [ "zipcode/SKK-JISYO.zipcode" "zipcode/SKK-JISYO.office.zipcode" ];
    license = lib.licenses.publicDomain;
  }
  {
    name = "JIS2";
    description = "SKK dictionary for JIS level 2 kanjis";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "JIS3_4";
    description = "SKK dictionary for JIS level 3 and 4 kanjis";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "JIS2004";
    description = ''
      A complementary SKK dictionary for JIS3_4 with JIS X 0213:2004 additions"
    '';
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "itaiji";
    description = "SKK dictionary for variant kanjis";
    license = lib.licenses.publicDomain;
  }
  {
    name = "itaiji.JIS3_4";
    description = "SKK dictionary for JIS level 3 and 4 variant kanjis";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "mazegaki";
    description = "SKK dictionary for mazegaki";
    license = lib.licenses.gpl2Plus;
  }
  {
    name = "emoji";
    description = "SKK dictionary for emojis";
    license = lib.licenses.unicode-dfs-2016;
  }
  {
    name = "pinyin";
    description = "SKK dictionary for pinyin to simplified Chinese input";
    license = lib.licenses.gpl1Plus;
  }
])
