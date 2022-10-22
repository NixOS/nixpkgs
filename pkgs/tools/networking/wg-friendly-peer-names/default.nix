{ stdenv
, lib
, fetchFromGitHub
, wireguard-tools
}:

stdenv.mkDerivation {
  pname = "wg-friendly-peer-names";
  version = "unstable-2021-11-08";

  src = fetchFromGitHub {
    owner = "FlyveHest";
    repo = "wg-friendly-peer-names";
    rev = "66b9b6b74ec77b9fec69b2a58296635321d4f5f1";
    sha256 = "pH/b5rCHIqLxz/Fnx+Dm0m005qAUWBsczSU9vGEQ2RQ=";
  };

  installPhase = ''
    install -D wgg.sh $out/bin/wgg
  '';

  meta = with lib; {
    homepage = "https://github.com/FlyveHest/wg-friendly-peer-names";
    description = "Small shellscript that makes it possible to give peers a friendlier and more readable name in the `wg` peer list";
    license = licenses.mit;
    platforms = wireguard-tools.meta.platforms;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "wgg";
  };
}
