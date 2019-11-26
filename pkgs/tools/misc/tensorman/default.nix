{ pkgconfig, stdenv, rustPlatform, rustc, cargo, docker, openssl, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "tensorman";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "tensorman";
    rev = version;
    sha256 = "0ywb53snvymmwh10hm6whckz7dwmpqa4rxiggd24y178jdfrm2ns";
  };

  buildInputs = [ pkgconfig openssl ];
  cargoSha256 = "1gh5w6zzrvjk60bqaf355fagijy723rvmqjh4laksd96pmzdfwn9";

  meta = with stdenv.lib; {
    description = "Utility for easy management of Tensorflow containers";
    homepage = "https://github.com/pop-os/tensorman/";
    license = stdenv.lib.licenses.gpl3;
    platforms =  [ "x86_64-linux" ];
    maintainers = with maintainers; [ thefenriswolf ];
  };
}
