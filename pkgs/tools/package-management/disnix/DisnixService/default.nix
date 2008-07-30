{stdenv, fetchsvn, jdk, apacheAnt, axis2, shebangfix}:

stdenv.mkDerivation {
    name = "DisnixService-0.1";
    src = fetchsvn {
	url = https://svn.nixos.org/repos/nix/disnix/DisnixService/trunk;
	md5 = "d58d2f313b9b6c18648f1a54a113d86a";
	rev = 12449;
    };
    
    buildInputs = [ jdk apacheAnt axis2 shebangfix ];
    builder = ./builder.sh;
    inherit axis2;
    
    meta = {
	license = "LGPL";
    };
}
