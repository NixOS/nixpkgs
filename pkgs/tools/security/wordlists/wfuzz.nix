{ lib
, stdenv
, wfuzz
}:

let
  shared = "wfuzz";

in stdenv.mkDerivation {
  pname = "wfuzz";
  inherit (wfuzz) version;

  src = wfuzz.src + "/wordlist";

  installPhase = ''
    mkdir -p $out/share
    cp -R "$src/" "$out/share/${shared}"
  '';

  passthru = { inherit shared; };

  meta = with lib; {
    inherit (wfuzz.meta) license homepage;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
