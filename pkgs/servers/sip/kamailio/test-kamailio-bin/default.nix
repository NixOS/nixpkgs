{ stdenv, kamailio }:

stdenv.mkDerivation {
  name = "kamailio-bin-test";
  meta.timeout = 60;
  src = ./.;

  dontInstall = true;

  buildPhase = ''
    mkdir $out

    ${kamailio}/bin/kamailio -v > $out/kamailio-stdout
    ${kamailio}/bin/kamcmd -h > $out/kamcmd-stdout
    (${kamailio}/bin/kamctl help || exit 0) > $out/kamctl-stdout
  '';

  doCheck = true;
  checkPhase = ''
    grep -q "version: kamailio" $out/kamailio-stdout || (echo "ERROR: kamailio cannot be run"; exit 1)
    grep -q "version: kamcmd" $out/kamcmd-stdout || (echo "ERROR: kamcmd cannot be run"; exit 1)
    grep -q "add a new subscriber" $out/kamctl-stdout || (echo "ERROR: kamctl cannot be run"; exit 1)
  '';
}
