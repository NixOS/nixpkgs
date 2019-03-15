{ stdenv, fetchurl }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "ngrok-${version}";
  version = "2.3.18";

  src = if stdenv.isLinux && stdenv.isi686 then fetchurl {
    url = "https://bin.equinox.io/a/dxXUN9EdeBT/ngrok-${version}-linux-386.tar.gz";
    sha256 = "108x3qchcklbkn7n3af0zxwpwmfp7wddblsn62ycnn9krcxhrn6f";
  } else if stdenv.isLinux && stdenv.isx86_64 then fetchurl {
    url = "https://bin.equinox.io/a/hUH1g1ZF2Gp/ngrok-${version}-linux-amd64.tar.gz";
    sha256 = "04zg6m8kv77wrh4bm5gpkzh1h348dlml04m786yb44x07klkc4lc";
  } else if stdenv.isDarwin then fetchurl {
    url = "https://bin.equinox.io/a/dGemqkBEuXf/ngrok-${version}-darwin-386.tar.gz";
    sha256 = "0zgfr0wmk7alz3qlal6x2knmxcp31gkljlhqgidi4d6wvv4c17zq";
  } else throw "platform ${stdenv.hostPlatform.system} not supported!";

  sourceRoot = ".";

  installPhase = ''
    install -D ngrok $out/bin/ngrok
  '';

  meta = {
    description = "ngrok";
    longDescription = ''
      Allows you to expose a web server running on your local machine to the internet.
    '';
    homepage = https://ngrok.com/;
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
