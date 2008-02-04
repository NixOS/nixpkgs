args: with args;

let

cfg = config.services.ejabberd;

ejabberdService = import ../services/ejabberd {
        inherit (cfg) user;
	inherit (pkgs) stdenv erlang ejabberd su;
};

in
{
	name = "ejabberd";
	job = "
description \"EJabberd server\"

stop on shutdown

respawn ${ejabberdService}/bin/control start
	";
}
