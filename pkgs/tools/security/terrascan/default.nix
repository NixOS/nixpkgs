{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terrascan";
<<<<<<< HEAD
  version = "1.18.3";
=======
  version = "1.18.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "accurics";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-2jIdKBNn3Ajvq+fQ1OuQ0VB8+S0QYwLZnJMlGqZ7WtE=";
  };

  vendorHash = "sha256-PH94le8IwVuinlRsk84HGSxhBSJTTJDrou7nfD1J1JM=";
=======
    hash = "sha256-w0ZOkPw8Y6Z1hyZecZfjd/YrTP8v6S0jNhgNzLjMRrY=";
  };

  vendorHash = "sha256-0WkOIgIA1fKn2SeS5QFeLGCGMstdlkU+eDRUVAs3ETA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Tests want to download a vulnerable Terraform project
  doCheck = false;

  meta = with lib; {
    description = "Detect compliance and security violations across Infrastructure";
    longDescription = ''
      Detect compliance and security violations across Infrastructure as Code to
      mitigate risk before provisioning cloud native infrastructure. It contains
      500+ polices and support for Terraform and Kubernetes.
    '';
    homepage = "https://github.com/accurics/terrascan";
    changelog = "https://github.com/tenable/terrascan/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
