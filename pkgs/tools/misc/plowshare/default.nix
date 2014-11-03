{ stdenv, fetchgit, makeWrapper, curl, spidermonkey }:

stdenv.mkDerivation rec {

  name = "plowshare4-${version}";

  version = "20140714.0x5s0zn8";

  src = fetchgit {
    url = "https://code.google.com/p/plowshare/";
    rev = "0b67463ca8684c3e9c93bd8164c461a41538e99f";
    sha256 = "0x5s0zn88w2h0740n4yms6fhwbb19kjwbhaj3k9wrnz4m3112s1m";
  };

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    make PREFIX="$out" install

    for fn in plow{del,down,list,up}; do
      wrapProgram "$out/bin/$fn" --prefix PATH : "${curl}/bin:${spidermonkey}/bin"
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
