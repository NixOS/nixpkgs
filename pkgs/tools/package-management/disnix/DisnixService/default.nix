{stdenv, fetchsvn, jdk, apacheAnt, axis2, shebangfix}:

stdenv.mkDerivation {
    name = "DisnixService-0.1";
    src = fetchsvn {
	url = https://svn.nixos.org/repos/nix/disnix/DisnixService/trunk;
	md5 = "019e4485e02b65a3402e885592cdd7f5";
	rev = 12653;
    };
    
    buildInputs = [ jdk apacheAnt axis2 shebangfix ];
    builder = ./builder.sh;
    inherit axis2;
    
    meta = {
	license = "LGPL";
    };
}
