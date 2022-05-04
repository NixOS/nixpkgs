{ lib, crystal, fetchFromGitHub, fetchurl, jq }:
let
  icon = fetchurl {
    url = "https://github.com/mawww/kakoune/raw/master/doc/kakoune_logo.svg";
    hash = "sha256-JxhIEmjiGrisaarA1sX1AfzNjHNIm9xjyPs/nG1uL/U=";
  };
in
crystal.buildCrystalPackage rec {
  pname = "kakoune.cr";
  version = "unstable-2021-11-12";

  src = fetchFromGitHub {
    owner = "alexherbo2";
    repo = "kakoune.cr";
    rev = "43d4276e1d173839f335ff60f205b89705892e00";
    hash = "sha256-xFrxbnZl/49vGKdkESPa6LpK0ckq4Jv5GNLL/G0qA1w=";
  };

  propagatedUserEnvPkgs = [ jq ];

  format = "shards";
  shardsFile = ./shards.nix;
  lockFile = ./shard.lock;

  preConfigure = ''
    substituteInPlace src/kakoune/version.cr --replace \
      '`git describe --tags --always`' \
      '"${version}"'
  '';

  postInstall = ''
    install -Dm555 share/kcr/commands/*/kcr-* -t $out/bin
    install -Dm444 share/kcr/applications/kcr.desktop -t $out/share/applications
    install -Dm444 ${icon} $out/share/icons/hicolor/scalable/apps/kcr.svg
    cp -r share/kcr $out/share/
  '';

  installCheckPhase = ''
    $out/bin/kcr --help
  '';

  meta = with lib; {
    homepage = "https://github.com/alexherbo2/kakoune.cr";
    description = "A command-line tool for Kakoune";
    license = licenses.unlicense;
    maintainers = with maintainers; [ malvo ];
    platforms = platforms.unix;
  };
}
