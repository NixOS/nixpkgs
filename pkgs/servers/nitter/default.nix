{ lib
, stdenv
, nixosTests
, fetchFromGitHub
, nim
, libsass
}:

let
  jester = fetchFromGitHub {
    owner = "dom96";
    repo = "jester";
    rev = "v0.5.0";
    sha256 = "0m8a4ss4460jd2lcbqcbdd68jhcy35xg7qdyr95mh8rflwvmcvhk";
  };
  karax = fetchFromGitHub {
    owner = "karaxnim";
    repo = "karax";
    rev = "1.1.2";
    sha256 = "07ykrd21hd76vlmkqpvv5xvaxw6aaq87bky47p2420ni85a6d94j";
  };
  sass = fetchFromGitHub {
    owner = "dom96";
    repo = "sass";
    rev = "e683aa1";
    sha256 = "0qvly5rilsqqsyvr67pqhglm55ndc4nd6v90jwswbnigxiqf79lc";
  };
  regex = fetchFromGitHub {
    owner = "nitely";
    repo = "nim-regex";
    rev = "2e32fdc";
    sha256 = "1hrl40mwql7nh4wc7sdhmk8bj5728b93v5a93j49v660l0rn4qx8";
  };
  unicodedb = fetchFromGitHub {
    owner = "nitely";
    repo = "nim-unicodedb";
    rev = "v0.9.0";
    sha256 = "06j8d0bjbpv1iibqlmrac4qb61ggv17hvh6nv4pbccqk1rlpxhsq";
  };
  unicodeplus= fetchFromGitHub {
    owner = "nitely";
    repo = "nim-unicodeplus";
    rev = "v0.8.0";
    sha256 = "181wzwivfgplkqn5r4crhnaqgsza7x6fi23i86djb2dxvm7v6qxk";
  };
  segmentation = fetchFromGitHub {
    owner = "nitely";
    repo = "nim-segmentation";
    rev = "v0.1.0";
    sha256 = "007bkx8dwy8n340zbp6wyqfsq9bh6q5ykav1ywdlwykyp1n909bh";
  };
  nimcrypto = fetchFromGitHub {
    owner = "cheatfate";
    repo = "nimcrypto";
    rev = "a5742a9a214ac33f91615f3862c7b099aec43b00";
    sha256 = "0al0jsaicm8vyr63n909dq1glhvpra1n9sllmj0r7lsjsdb59wsz";
  };
  markdown = fetchFromGitHub {
    owner = "soasme";
    repo = "nim-markdown";
    rev = "abdbe5e";
    sha256 = "0f3c1sxvhbbds43c9l8cz69pfpf984msj1lv4pb7bzpxb5zil2wy";
  };
  packedjson = fetchFromGitHub {
    owner = "Araq";
    repo = "packedjson";
    rev = "7198cc8";
    sha256 = "1ay2zd88q8hvpvigsg8h0y5vc65hk3lk0d48fy9hwg4lcng19mp1";
  };
  supersnappy = fetchFromGitHub {
    owner = "guzba";
    repo = "supersnappy";
    rev = "1.1.5";
    sha256 = "1y26sgnszvdf5sn7j0jx2dpd4i03mvbk9i9ni9kbyrs798bjwi6z";
  };
  redpool = fetchFromGitHub {
    owner = "zedeus";
    repo = "redpool";
    rev = "57aeb25";
    sha256 = "0fph7qlia6fvya1zqzbgvww2hk5pd0vq1wlf9ij9jyn655mg0w3q";
  };
  frosty = fetchFromGitHub {
    owner = "disruptek";
    repo = "frosty";
    rev = "0.3.1";
    sha256 = "0hd6484ihjgl57gmqyp5xfq5prycb49k0313fqky600mhz71nmyz";
  };
  redis = fetchFromGitHub {
    owner = "zedeus";
    repo = "redis";
    rev = "94bcbf1";
    sha256 = "1p9zv4f4lqrjqa8fk98cb89b9fzlf866jc584ll9sws14904i80j";
  };
in stdenv.mkDerivation rec {
  pname = "nitter";
  version = "unstable-2021-07-18";

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "6c5cb01b294d4f6e3b438fc47683359eb0fe5057";
    sha256 = "1dl8ndyv8m1hnydrp5xilcpp2cfbp02d5jap3y42i4nazc9ar6p4";
  };

  nativeBuildInputs = [ nim ];
  buildInputs = [ libsass ];

  buildPhase = ''
    runHook preBuild
    export HOME=$TMPDIR
    nim -d:release -p:${jester} -p:${karax} -p:${sass}/src -p:${regex}/src -p:${unicodedb}/src -p:${unicodeplus}/src -p:${segmentation}/src -p:${nimcrypto} -p:${markdown}/src -p:${packedjson} -p:${supersnappy}/src -p:${redpool}/src -p:${frosty} -p:${redis}/src c src/$pname
    nim -p:${sass}/src c --hint[Processing]:off -r tools/gencss
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin src/$pname
    mkdir -p $out/share/nitter
    cp -r public $out/share/nitter/public
    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) nitter;
  };

  meta = with lib; {
    description = "Alternative Twitter front-end";
    homepage = "https://github.com/zedeus/nitter";
    maintainers = with maintainers; [ erdnaxe ];
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}

