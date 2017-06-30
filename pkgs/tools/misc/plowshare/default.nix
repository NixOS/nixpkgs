{ stdenv, fetchFromGitHub, makeWrapper, curl, recode, spidermonkey }:

stdenv.mkDerivation rec {

  name = "plowshare-${version}";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "mcrapet";
    repo = "plowshare";
    rev = "v${version}";
    sha256 = "116291w0z1r61xm3a3zjlh85f05pk4ng9f1wbj9kv1j3xrjn4v4c";
  };

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    make PREFIX="$out" install

    for fn in plow{del,down,list,mod,probe,up}; do
      wrapProgram "$out/bin/$fn" --prefix PATH : "${stdenv.lib.makeBinPath [ curl recode spidermonkey ]}"
    done
  '';

  meta = {
    description = ''
      A command-line download/upload tool for popular file sharing websites
    '';
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ aforemny jfrankenau ];
    platforms = stdenv.lib.platforms.linux;
  };
}
