{stdenv, fetchsvn, jdk, apacheAnt, axis2, shebangfix}:

stdenv.mkDerivation {
    name = "DisnixService-0.1";
    src = fetchsvn {
	url = https://svn.nixos.org/repos/nix/disnix/DisnixService/trunk;
	md5 = "13e0a12292a2e1fb1049ef102863e64b";
	rev = 12590;
    };
    
    buildInputs = [ jdk apacheAnt axis2 shebangfix ];
    builder = ./builder.sh;
    inherit axis2;
    
    meta = {
	license = "LGPL";
    };
}
