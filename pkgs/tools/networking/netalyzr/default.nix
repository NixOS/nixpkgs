{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "netalyzr-${version}";
  version = "57861";

  # unfortunately there is not a version specific download URL
  src = fetchurl {
    url    = "http://netalyzr.icsi.berkeley.edu/NetalyzrCLI.jar";
    sha256 = "0fa3gvgp05p1nf1d711052wgvnp0xnvhj2h2bwk1mh1ih8qn50xb";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/{bin,share/netalyzr}
    install -m644 $src $out/share/netalyzr/NetalyzrCLI.jar
    cat <<_EOF >> $out/bin/netalyzr
    #!${stdenv.shell}

    set -euo pipefail

    exec ${stdenv.lib.getBin jre}/bin/java -jar $out/share/netalyzr/NetalyzrCLI.jar "\$@"
    _EOF
    chmod 755 $out/bin/netalyzr
  '';

  meta = with stdenv.lib; {
    description = "Network debugging and analysis tool";
    homepage    = http://netalyzr.icsi.berkeley.edu;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.all;
  };
}
