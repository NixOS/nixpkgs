{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "quake3demo-1.11-6";
  builder = ./builder.sh;

  # This is needed for pak0.pk3.
  demo = fetchurl {
    url = http://tarballs.nixos.org/linuxq3ademo-1.11-6.x86.gz.sh;
    sha256 = "1v54a1hx1bczk9hgn9qhx8vixsy7xn7wj2pylhfjsybfkgvf7pk4";
  };

  # This is needed for the additional pak?.pk3 files.
  update = fetchurl {
    url = http://tarballs.nixos.org/linuxq3apoint-1.31.x86.run;
    sha256 = "1kp689452zb8jhd67ghisz2055pqxy9awz4vi0hq5qmp7xrp1x58";
  };

  # Don't rebuild if the inputs change, since the output is guaranteed
  # to be this value.
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "00453c43a4jnlbm9w9ws1hdi28hkl63xnxbnbqml25h35ckhzs90";
}
