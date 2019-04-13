{ stdenv, fetchurl }:

let
  platformSpecific = {
    x86_64-linux = {
      sha256 = "caa86a00d0ede8485bf855276ac1b2e411a5e99de612696b137ea3519a8e4967";
      string = "x86_64-unknown-linux-gnu";
    };
    x86_64-darwin = {
      sha256 = "eb5ceb534629dcf5d57640bf672ea0d94ac02e264209ab3a29e6bda8a44d3b8f";
      string = "x86_64-apple-darwin";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported platform");
in
stdenv.mkDerivation rec {
  pname = "tabnine";
  version = "1.0.12";

  src = fetchurl {
    inherit (platformSpecific) sha256;
    url = "https://update.tabnine.com/${version}/${platformSpecific.string}/TabNine";
  };

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/TabNine
    chmod +x $out/bin/TabNine
  '';

  meta = with stdenv.lib; {
    description = "TabNine is the all-language autocompleter. It uses machine learning to provide responsive, reliable, and relevant suggestions.";
    homepage = https://tabnine.com/;
    # Exchanged emails with author to include in nix. Quote from tabnine author: "Thanks for adding TabNine to NixOS"
    license = stdenv.lib.licenses.unfreeRedistributable;
    maintainers = with maintainers; [ softinio ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
