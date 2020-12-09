{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "darwin-stubs";
  version = "10.12";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "darwin-stubs";
    rev = "80b3d4a57d3454c975eefd984c804dbd76f04ef2";
    sha256 = "0sslg4rmskms8ixixv1gvnrvvvmn723vbfjj6mcn24fj2ncg38y7";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -vr stubs/$version/* $out
  '';
}
