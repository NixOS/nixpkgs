{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "qr-filetransfer-unstable-${version}";
  version = "2018-10-22";

  goPackagePath = "github.com/claudiodangelis/qr-filetransfer";

  src = fetchFromGitHub {
    rev = "b1e5b91aa2aa469f870c62074e879d46e353edae";
    owner = "claudiodangelis";
    repo = "qr-filetransfer";
    sha256 = "04cl3v6bzpaxp1scpsa42xxa1c1brbplq408bb7nixa98bacj4x1";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/claudiodangelis/qr-filetransfer;
    description = "Transfer files over wifi by scanning a QR code from your terminal";
    longDescription = ''
      qr-filetransfer binds a web server to the address of your Wi-Fi network
      interface on a random port and creates a handler for it. The default
      handler serves the content and exits the program when the transfer is
      complete.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
