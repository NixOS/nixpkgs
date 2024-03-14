{
  lib,
  buildBazelPackage,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchurl,
  qt6,
  pkg-config,
  bazel,
  ibus,
  unzip,
  python3,
  xdg-utils,
  ruby,
  glibcLocales,
  useUTDictionaries ? false,
}: let
  _zipcode_rel = "202110";
  zip-codes = fetchFromGitHub {
    owner = "musjj";
    repo = "jp-zip-codes";
    rev = "a1eed9bae0ba909c8c8f5387008b08ff490f5e57";
    hash = "sha256-VfI8qAMPPCC2H4vjm4a6sAmSwc1YkXlMyLm1cnufvrU=";
  };
  fcitx5-mozc-ut = fetchFromGitLab {
    owner = "BrLi";
    repo = "brli-aur";
    rev = "1b929f03a07e3b8104158367471cde14fafe0c82";
    hash = "sha256-270sSOJIw1SNTIMla3jTXK6VnSFeQjLyfadUayYxtZQ=";
  };
  merge-ut-dictionaries = fetchFromGitHub {
    name = "merge-ut-dictionaries";
    owner = "utuhiro78";
    repo = "merge-ut-dictionaries";
    rev = "a3d6fc4005aff2092657ebca98b9de226e1c617f";
    hash = "sha256-UK29ACZUK9zGfzW7C85uMw2aF5Gk+0aDeUdNV71PY+0=";
  };
  jawiki = let
    date = "20240301";
  in
    fetchurl {
      url = "https://dumps.wikimedia.org/jawiki/${date}/jawiki-${date}-all-titles-in-ns0.gz";
      hash = "sha256-tq/sKAPZ/NLplOLoVWp2ZdWzK/F7TVA9FTCYKfvFuZU=";
    };
  getDict = name: rev: hash: let
    repo = fetchFromGitHub {
      inherit rev hash;
      owner = "utuhiro78";
      repo = "mozcdic-ut-${name}";
    };
  in "${repo}/mozcdic-ut-${name}.txt.tar.bz2";
in
buildBazelPackage rec {
  pname = "ibus-mozc";
  version = "2.29.5268.102";

  srcs =
    [
      (fetchFromGitHub {
        owner = "google";
        repo = "mozc";
        rev = version;
        hash = "sha256-B7hG8OUaQ1jmmcOPApJlPVcB8h1Rw06W5LAzlTzI9rU=";
        fetchSubmodules = true;
      })
    ]
    ++ lib.optional useUTDictionaries [
      "${fcitx5-mozc-ut}/x-ken-all-${_zipcode_rel}.zip"
      "${fcitx5-mozc-ut}/jigyosyo-${_zipcode_rel}.zip"
      merge-ut-dictionaries
      (getDict "alt-cannadic" "4e548e6356b874c76e8db438bf4d8a0b452f2435" "sha256-4gzqVoCIhC0k3mh0qbEr8yYttz9YR0fItkFNlu7cYOY=")
      (getDict "edict2" "16283aa0c2d394a3a000eca4fa3e95eb365698c6" "sha256-H4Y6RGFZBQodpB4cM3o3MPFJGs/xMvbIB/c8CazY1b4=")
      (getDict "jawiki" "bd82687d32ae838f1e163d3d2c6ad18740af53f2" "sha256-AjNNV1V5fTMhlR2Nv6g+zNuCCLmPlQUJtUw7JigQKdM=")
      (getDict "neologd" "bf9d0d217107f2fb2e7d1a26648ef429d9fdcd27" "sha256-e0iM5fohwpNNhPl9CjkD753/Rgatg7GdwN0NSvlN94c=")
      (getDict "personal-names" "6cc099cefc928bc37854c538e030114df3d5b42d" "sha256-PqbS6VC70IaHJqxP9518zTTZuvXggAsRGeYPiN5T0XU=")
      (getDict "place-names" "a847a02e0137ab9e2fdbbaaf120826f870408ca6" "sha256-B0kW8Wa/nCT4KEYl2Rz6gQcj0Po3GxU6i42unHhgZeU=")
      (getDict "skk-jisyo" "ee94f6546ce52edfeec0fd203030f52d4d99656f" "sha256-RXxO878ZBkxenrdo7cFom5NjM0m7CdYQk0dFu/HPp/Y=")
      (getDict "sudachidict" "55f61c3fca81dec661c36c73eb29b2631c8ed618" "sha256-gNnBcuVU1M7rllfZXIrLg7WYUhKqPJsUjR8Scnq3Fw8=")
    ];
  sourceRoot = "source";

  nativeBuildInputs = [qt6.wrapQtAppsHook pkg-config unzip] ++ lib.optional useUTDictionaries [python3 ruby glibcLocales];

  buildInputs = [ibus qt6.qtbase];

  dontAddBazelOpts = true;
  removeRulesCC = false;

  inherit bazel;

  fetchAttrs = {
    sha256 = "sha256-17QHh1MJUu8OK/T+WSpLXEx83DmRORLN7yLzILqP7vw=";

    # remove references of buildInputs
    preInstall = ''
      rm -rv $bazelOut/external/{ibus,qt_linux}
    '';
  };

  bazelFlags = [ "--config" "oss_linux" "--compilation_mode" "opt" ];

  bazelTargets = [ "package" ];

  postPatch = ''
    substituteInPlace src/config.bzl \
      --replace-fail "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open" \
      --replace-fail "/usr" "$out"
    substituteInPlace src/WORKSPACE.bazel \
      --replace-fail "https://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip" "file://${zip-codes}/ken_all.zip" \
      --replace-fail "https://www.post.japanpost.jp/zipcode/dl/jigyosyo/zip/jigyosyo.zip" "file://${zip-codes}/jigyosyo.zip"
  '';

  preConfigure =
    ''
      srcdir="$(dirname "$PWD")"
      cd src
    ''
    + lib.optionalString useUTDictionaries ''
      PYTHONPATH="$PWD:$PYTHONPATH" python3 dictionary/gen_zip_code_seed.py --zip_code="$srcdir/x-ken-all.csv" --jigyosyo="$srcdir/JIGYOSYO.CSV" >> data/dictionary_oss/dictionary09.txt
      cd $srcdir/merge-ut-dictionaries/src
      chmod +w $PWD
      for dict in $srcdir/mozcdic-ut-*; do
        cat "$dict" >> mozcdic-ut.txt
      done
      sed '/^`wget*/d' -i count_word_hits.rb
      sed "s,https://raw.githubusercontent.com/google/mozc/master,$srcdir/source," -i remove_duplicate_ut_entries.rb
      cp ${jawiki} ./jawiki-latest-all-titles-in-ns0.gz
      export LANG=en_US.UTF-8
      export LANGUAGE=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
      ruby remove_duplicate_ut_entries.rb mozcdic-ut.txt
      ruby count_word_hits.rb
      ruby apply_word_hits.rb mozcdic-ut.txt
      cat mozcdic-ut.txt >> "$srcdir/source/src/data/dictionary_oss/dictionary00.txt"
      cd $srcdir/source/src
    '';

  buildAttrs = {
    PYTHONUTF8 = 1;

    installPhase = ''
      runHook preInstall

      unzip bazel-bin/unix/mozc.zip -x "tmp/*" -d /

      runHook postInstall
    '';
  };

  passthru = {
    inherit zip-codes;
  };

  meta = with lib; {
    isIbusEngine = true;
    description = "Japanese input method from Google";
    homepage = "https://github.com/google/mozc";
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner ericsagnes pineapplehunter programmerino ];
  };
}
