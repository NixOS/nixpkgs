{ lib, stdenv, fetchFromGitHub, makeWrapper, wget, jq, curl }:

let
  version = "1.0";
in
stdenv.mkDerivation {
  pname = "hedgedoc-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "hedgedoc";
    repo = "cli";
    rev = "v${version}";
    sha256 = "uz+lkRRUTRr8WR295esNEbgjlZ/Em7mBk6Nx0BWLfg4=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/bin/codimd $out/bin
    wrapProgram $out/bin/codimd \
      --prefix PATH : ${lib.makeBinPath [ jq wget curl ]}
    ln -s $out/bin/codimd $out/bin/hedgedoc-cli
    runHook postInstall
  '';

  checkPhase = ''
    hedgedoc-cli help
  '';

  meta = with lib; {
    description = "Hedgedoc CLI";
    homepage = "https://github.com/hedgedoc/cli";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ drupol ];
  };
}
