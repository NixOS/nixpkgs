{ lib, stdenv, fetchurl }:
let
  arch_table = {
    "x86_64-linux" = "linux-x86_64";
    "i686-linux" = "linux-i686";
  };

  sha_table = {
    "x86_64-linux" =
      "d9902aadac4f442992877945da2a6fe8d6ea6b0de314ca8ac0c28dc5f253f7d8";
    "i686-linux" =
      "46deb0a053b4910c4e68737a7b6556ff5360260c8f86652f91a0130445f5c949";
  };

  arch = arch_table.${stdenv.system};
  sha = sha_table.${stdenv.system};
in
stdenv.mkDerivation rec {
  pname = "essentia-extractor";
  version = "2.1_beta2";

  src = fetchurl {
    url = "ftp://ftp.acousticbrainz.org/pub/acousticbrainz/essentia-extractor-v${version}-${arch}.tar.gz";
    sha256 = sha;
  };

  unpackPhase = "unpackFile $src ; export sourceRoot=.";

  installPhase = ''
    mkdir -p $out/bin
    cp streaming_extractor_music $out/bin
  '';

  meta = with lib; {
    homepage = "https://acousticbrainz.org/download";
    description = "AcousticBrainz audio feature extractor";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
