{ stdenvNoCC
, lib
, coreutils
, curl
, jq
, unzip
, nix
}:

stdenvNoCC.mkDerivation rec {
  pname = "nix-prefetch-vscode-mktplc";
  version = "0.1.0";

  src = ./nix-prefetch-vscode-mktplc;

  dontUnpack = true;

  buildInputs = [
    coreutils
    curl
    jq
    unzip
    nix
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/${pname}
    chmod +x $out/bin/${pname}
  '';

  postFixup = ''
    sed -i "2 i export PATH=${lib.makeBinPath buildInputs}" "$out/bin/${pname}"
  '';

  meta = with lib; {
    description = "Prefetch vscode extensions from the official marketplace";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
