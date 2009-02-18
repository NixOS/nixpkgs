{stdenv, fetchurl, cracklib, flex}:

stdenv.mkDerivation {
  name = "linux-pam-1.0.3";

  src = fetchurl {
    url = mirror://kernel/linux/libs/pam/library/Linux-PAM-1.0.3.tar.bz2;
    sha256 = "1xqj4ibnid5w3pi629vj7jiddf192kzm8rbm3vy90diqpl1k5h6n";
  };

  buildInputs = [flex cracklib];

  CRACKLIB_DICTPATH = "${cracklib}/lib";

  preConfigure = ''
    configureFlags="$configureFlags --includedir=$out/include/security"
  '';
}
