args: with args;

let

cfg = config.services.jboss;
jbossService = import ../services/jboss {
        inherit (pkgs) stdenv jboss su;
        inherit (cfg) tempDir logDir libUrl deployDir serverDir user useJK;
};

in
{
        name = "jboss";
        job = "
description \"JBoss server\"

stop on shutdown

respawn ${jbossService}/bin/control start
        ";
}
