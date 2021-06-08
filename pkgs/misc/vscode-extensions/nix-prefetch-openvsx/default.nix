{ stdenvNoCC
, lib
, coreutils
, curl
, jq
, unzip
, nix
}:

stdenvNoCC.mkDerivation rec {
  pname = "nix-prefetch-openvsx";
  version = "0.1.0";

  src = ./nix-prefetch-openvsx;

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
    description = "Prefetch vscode extensions from Open VSX Registry";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
