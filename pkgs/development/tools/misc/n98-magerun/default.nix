{ stdenv, fetchFromGitHub, makeWrapper, unzip, lib, php80 }:

let
  pname = "n98-magerun";
  version = "2.3.0";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun1-dist";
    rev = version;
    sha256 = "sha256-T7wQmEEYMG0J6+9nRt+tiMuihjnjjQ7UWy1C0vKoQY4=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src/n98-magerun $out/libexec/n98-magerun/n98-magerun-${version}.phar
    makeWrapper ${php80}/bin/php $out/bin/n98-magerun \
      --add-flags "$out/libexec/n98-magerun/n98-magerun-${version}.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "The swiss army knife for Magento1/OpenMage developers";
    license = licenses.mit;
    homepage = "https://magerun.net/";
    changelog = "https://magerun.net/category/magerun/";
    maintainers = teams.php.members;
  };
}
