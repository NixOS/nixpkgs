{stdenv, fetchsvn, autoconf, automake}:

stdenv.mkDerivation {
  name = "disnix-activation-scripts-nixos";
  src = fetchsvn {
    url = https://svn.nixos.org/repos/nix/disnix/disnix-activation-scripts-nixos/trunk;
    sha256 = "3ba44fbd2c00da6dd1926513184db89c1f3557c55af5c3a4041e85fb6d1a5758";
  };
  buildInputs = [ autoconf automake ];
  preConfigure = "./bootstrap";
}
