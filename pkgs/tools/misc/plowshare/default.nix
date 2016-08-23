{ stdenv, fetchFromGitHub, makeWrapper, curl, spidermonkey }:

stdenv.mkDerivation rec {

  name = "plowshare4-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mcrapet";
    repo = "plowshare";
    rev = "v${version}";
    sha256 = "1xxkdv4q97dfzbcdnmy5079a59fwh8myxlvdr2dlxdv70fb72sq9";
  };

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    make PREFIX="$out" install

    for fn in plow{del,down,list,up}; do
      wrapProgram "$out/bin/$fn" --prefix PATH : "${stdenv.lib.makeBinPath [ curl spidermonkey ]}"
    done
  '';

  meta = {
    description = ''
      A command-line download/upload tool for popular file sharing websites
    '';
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.aforemny ];
    platforms = stdenv.lib.platforms.linux;
  };
}
