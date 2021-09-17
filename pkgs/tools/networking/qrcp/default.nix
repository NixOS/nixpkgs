{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "qrcp";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "claudiodangelis";
    repo = "qrcp";
    rev = version;
    sha256 = "1m1xbb3x526j2v8m5m46km9zzj3dk9fvm5wckyqb8kxm4md12y50";
  };

  vendorSha256 = "1hn8c72fvih6ws1y2c4963pww3ld64m0yh3pmx62hwcy83bhb0v4";

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --bash --cmd qrcp <($out/bin/qrcp completion bash)
    installShellCompletion --fish --cmd qrcp <($out/bin/qrcp completion fish)
    installShellCompletion --zsh  --cmd qrcp <($out/bin/qrcp completion zsh)
  '';

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
