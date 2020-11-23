{ lib
, pkgs
, stdenv
}:

let
  shared = "wfuzz";

in stdenv.mkDerivation {
  pname = "wfuzz";
  version = pkgs.wfuzz.version;

  src = pkgs.wfuzz.src + "/wordlist";

  installPhase = ''
    mkdir -p $out/share
    cp -R "$src/" "$out/share/${shared}"
  '';

  passthru = { inherit shared; };

  meta = with lib; {
    inherit (pkgs.wfuzz.meta) license homepage;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
