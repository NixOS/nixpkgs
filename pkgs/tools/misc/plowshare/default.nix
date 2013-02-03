{ stdenv, fetchurl, makeWrapper, curl }:

stdenv.mkDerivation rec {

  name = "plowshare4-${version}";

  version = "20121126.47e4480";

  src = fetchurl {
    url = "http://plowshare.googlecode.com/files/plowshare4-snapshot-git${version}.tar.gz";
    sha256 = "1p7bqqfbgcy41hiickgr8cilspyvrrql12rdmfasz0dmgf7nx1x6";
  };

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    make PREFIX="$out" install

    for fn in plow{del,down,list,up}; do
      wrapProgram "$out/bin/$fn" --prefix PATH : "${curl}/bin"
    done
  '';

  meta = {
    description = ''
      A command-line download/upload tool for popular file sharing websites
    '';
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.aforemny ];
  };
}
