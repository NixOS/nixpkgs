{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nuclei";
<<<<<<< HEAD
  version = "2.9.14";
=======
  version = "2.9.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-73MOUzIWA2sO6Y+Xku7f7DlUtsoa0GpfaqJzpEHCV/M=";
  };

  vendorHash = "sha256-H4QBt00WSvCJi7P6gh4JBDCLSZwt/H5LWcahusdQoRE=";
=======
    rev = "v${version}";
    hash = "sha256-WqbJlpKwkbYWvSwVqhcPyIeKdlaNOvxmJh3XKi7b/Do=";
  };

  vendorHash = "sha256-yIGK7Fyr616XrZ5tQCdzontlCFegn9utrV8ZXhUQzp4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  modRoot = "./v2";
  subPackages = [
    "cmd/nuclei/"
  ];

  # Test files are not part of the release tarball
  doCheck = false;

  meta = with lib; {
    description = "Tool for configurable targeted scanning";
    longDescription = ''
      Nuclei is used to send requests across targets based on a template
      leading to zero false positives and providing effective scanning
      for known paths. Main use cases for nuclei are during initial
      reconnaissance phase to quickly check for low hanging fruits or
      CVEs across targets that are known and easily detectable.
    '';
    homepage = "https://github.com/projectdiscovery/nuclei";
    changelog = "https://github.com/projectdiscovery/nuclei/releases/tag/v${version}";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ fab Misaka13514 ];
=======
    maintainers = with maintainers; [ fab ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
