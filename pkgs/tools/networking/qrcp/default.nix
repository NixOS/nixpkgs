{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "qrcp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "claudiodangelis";
    repo = "qrcp";
    rev = version;
    sha256 = "0rx0pzy7p3dklayr2lkmyfdc00x9v4pd5xnzydbjx12hncnkpw4l";
  };

  vendorSha256 = "0iffy43x3njcahrxl99a71v8p7im102nzv8iqbvd5c6m14rsckqa";

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://claudiodangelis.com/qrcp/";
    description = "Transfer files over wifi by scanning a QR code from your terminal";
    longDescription = ''
      qrcp binds a web server to the address of your Wi-Fi network
      interface on a random port and creates a handler for it. The default
      handler serves the content and exits the program when the transfer is
      complete.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
