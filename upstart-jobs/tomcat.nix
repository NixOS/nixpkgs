args: with args;

let

cfg = config.services.tomcat;
tomcatService = import ../services/tomcat {
	inherit (pkgs) stdenv jdk tomcat6 su;
	inherit (cfg) baseDir user;
};

in
{
	name = "tomcat";
	job = "
description \"Apache Tomcat server\"

stop on shutdown

respawn ${tomcatService}/bin/control start
	";
}
