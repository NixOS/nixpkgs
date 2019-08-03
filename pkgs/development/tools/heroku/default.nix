{ stdenv, lib, fetchurl, makeWrapper, nodejs }:

stdenv.mkDerivation rec {
  pname = "heroku";
  version = "7.22.4";

  src = fetchurl {
    url = "https://cli-assets.heroku.com/heroku-v${version}/heroku-v${version}.tar.xz";
    sha256 = "067kvkdn7yvzb3ws6yjsfbypww914fclhnxrh2dw1hc6cazfgmqp";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/heroku $out/bin
    cp -pr * $out/share/heroku
    substituteInPlace $out/share/heroku/bin/run \
      --replace "/usr/bin/env node" "${nodejs}/bin/node"
    makeWrapper $out/share/heroku/bin/run $out/bin/heroku \
      --set HEROKU_DISABLE_AUTOUPDATE 1
  '';

  meta = {
    homepage = https://cli.heroku.com;
    description = "Everything you need to get started using Heroku";
    maintainers = with lib.maintainers; [ aflatter mirdhyn peterhoeg ];
    license = lib.licenses.mit;
    platforms = with lib.platforms; unix;
  };
}
