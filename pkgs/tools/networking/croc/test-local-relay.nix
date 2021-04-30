{ stdenv, croc }:

stdenv.mkDerivation {
  name = "croc-test-local-relay";
  meta.timeout = 300;
  buildCommand = ''
          HOME=$(mktemp -d)
          # start a local relay
          ${croc}/bin/croc relay --ports 11111,11112 &
          # start sender in background
          MSG="See you later, alligator!"
          ${croc}/bin/croc --relay localhost:11111 send --code correct-horse-battery-staple --text "$MSG" &
          # wait for things to settle
          sleep 1
          # receive, as of croc 9 --overwrite is required for noninteractive use
          MSG2=$(${croc}/bin/croc --overwrite --relay localhost:11111 --yes correct-horse-battery-staple)
          # compare
          [ "$MSG" = "$MSG2" ] && touch $out
  '';
}
