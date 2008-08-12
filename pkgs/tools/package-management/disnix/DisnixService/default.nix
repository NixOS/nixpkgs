{stdenv, fetchsvn, jdk, apacheAnt, axis2, shebangfix}:

stdenv.mkDerivation {
    name = "DisnixService-0.1";
    src = fetchsvn {
	url = https://svn.nixos.org/repos/nix/disnix/DisnixService/trunk;
	md5 = "a39b65b7f56f94534e0b7e2ca318b4d2";
	rev = 12594;
    };
    
    buildInputs = [ jdk apacheAnt axis2 shebangfix ];
    builder = ./builder.sh;
    inherit axis2;
    
    meta = {
	license = "LGPL";
    };
}
