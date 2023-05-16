{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tlsx";
<<<<<<< HEAD
  version = "1.1.4";
=======
  version = "1.0.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-EMTNd5NOvaFbVxv31j3pBU//mWQQpThswCT8bMNx5Qw=";
  };

  vendorHash = "sha256-5fS10G1YxtyhMZcpaqYy9P6eX/xQABYVZj1HX6WxQxo=";
=======
    hash = "sha256-1lI4UyfUb+gXFwIfSauS/TBzEqrwQSY1UqzFDRXEBuE=";
  };

  vendorHash = "sha256-xPKdyTXu2SUU5y5bk+8gZklG6QyAEdl+8LwJizvW9+o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "TLS grabber focused on TLS based data collection";
    longDescription = ''
      A fast and configurable TLS grabber focused on TLS based data
      collection and analysis.
    '';
    homepage = "https://github.com/projectdiscovery/tlsx";
    changelog = "https://github.com/projectdiscovery/tlsx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
