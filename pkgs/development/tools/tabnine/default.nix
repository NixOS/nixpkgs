{ stdenv, fetchurl }:

let
  hashes = {
    x86_64-linux   = "caa86a00d0ede8485bf855276ac1b2e411a5e99de612696b137ea3519a8e4967";
    x86_64-darwin  = "eb5ceb534629dcf5d57640bf672ea0d94ac02e264209ab3a29e6bda8a44d3b8f";
  };
in
stdenv.mkDerivation rec {
  name = "tabnine-${version}";
  version = "1.0.12";

  platformString =
    if stdenv.isDarwin then "x86_64-apple-darwin"
    else if stdenv.isLinux then "x86_64-unknown-linux-gnu"
    else throw "unsupported platform";

  src = fetchurl {
    url = "https://update.tabnine.com/${version}/${platformString}/TabNine";
    sha256 = hashes.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/TabNine
    chmod +x $out/bin/TabNine
  '';

  meta = with stdenv.lib; {
    description = "TabNine is the all-language autocompleter. It uses machine learning to provide responsive, reliable, and relevant suggestions.";
    homepage = https://tabnine.com/;
    license = stdenv.lib.licenses.unfreeRedistributable;
    maintainers = with maintainers; [ softinio ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
