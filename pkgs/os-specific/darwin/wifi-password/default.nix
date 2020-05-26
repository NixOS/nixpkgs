{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.1.0";
  pname = "wifi-password";

  src = fetchFromGitHub {
    owner = "rauchg";
    repo = pname;
    rev = version;
    sha256 = "0sfvb40h7rz9jzp4l9iji3jg80paklqsbmnk5h7ipsv2xbsplp64";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp wifi-password.sh $out/bin/wifi-password
  '';

  meta = {
    homepage = "https://github.com/rauchg/wifi-password";
    description = "Get the password of the wifi you're on";
    platforms = stdenv.lib.platforms.darwin;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.nikitavoloboev ];
  };
}
