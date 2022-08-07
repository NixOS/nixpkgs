{ lib, stdenv, fetchFromGitHub, wget, jq, curl }:

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

  buildInputs = [
    wget
    jq
    curl
  ];

  installPhase = ''
    runHook preInstall
    install -Dm0755 -t $out/bin $src/bin/codimd
    ln -s $out/bin/codimd $out/bin/hedgedoc-cli
    runHook postInstall
  '';

  checkPhase = ''
    hedgedoc-cli help
  '';

  meta = with lib; {
    description = "Hedgedoc CLI";
    homepage = "https://github.com/hedgedoc/cli";
    license = licenses.agpl3;
    maintainers = with maintainers; [ drupol ];
  };
}
