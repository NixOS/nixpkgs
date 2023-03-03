{ stdenv, fetchFromGitHub, makeWrapper, unzip, lib, php }:

let
  pname = "n98-magerun2";
  version = "6.1.1";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun2-dist";
    rev = version;
    sha256 = "sha256-D2U1kLG6sOpBHDzNQ/LbiFUknvFhK+rkOPgWvW0pNmY=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src/n98-magerun2 $out/libexec/n98-magerun2/n98-magerun2-${version}.phar
    makeWrapper ${php}/bin/php $out/bin/n98-magerun2 \
      --add-flags "$out/libexec/n98-magerun2/n98-magerun2-${version}.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "The swiss army knife for Magento2 developers";
    license = licenses.mit;
    homepage = "https://magerun.net/";
    changelog = "https://magerun.net/category/magerun/";
    maintainers = teams.php.members;
  };
}
