#{ pkgconfig, stdenv, rustPlatform, rustc, cargo, docker, openssl, fetchzip }:

rustPlatform.buildRustPackage rec {
  name = "tensorman-${version}";
  version = "0.1.0";

 src = fetchzip{
    url = "https://github.com/pop-os/tensorman/archive/master_eoan.zip";
    sha256 = "10srpa3m6bdx0hx9w0p4n699j3c6hw8xx7l2p6r0g2d2d8nakwyf";
  };

 #  src = fetchFromGitHub { # revert this to fetch from Github when upstream has github releases
 #   owner = "pop-os";
 #   repo = "tensorman";
 #   rev = version;
 
cargoSha256 = "1gh5w6zzrvjk60bqaf355fagijy723rvmqjh4laksd96pmzdfwn9";

  meta = with stdenv.lib; {
    description = "Utility for easy management of Tensorflow containers";
    homepage = https://github.com/pop-os/tensorman/;
    license = stdenv.lib.licenses.gpl3;
    platforms =  [ "x86_64-linux" ];
    maintainers = [  ];
  };
}
