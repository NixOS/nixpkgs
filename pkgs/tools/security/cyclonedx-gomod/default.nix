{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cyclonedx-gomod";
<<<<<<< HEAD
  version = "1.4.1";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JczDfNBYT/Ap2lDucEvuT8NAwuQgmavOUvtznI6Q+Zc=";
  };

  vendorHash = "sha256-5Mn+f+oVwbn2qGaZct5+9f6tOBXfsB/I72yD7fHUrC8=";
=======
    hash = "sha256-GCRLOfrL1jFExGb5DbJa8s7RQv8Wn81TGktShZqeC54=";
  };

  vendorHash = "sha256-gFewqutvkFc/CVpBD3ORGcfiG5UNh5tQ1ElHpM3g5+I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Tests require network access and cyclonedx executable
  doCheck = false;

  meta = with lib; {
    description = "Tool to create CycloneDX Software Bill of Materials (SBOM) from Go modules";
    homepage = "https://github.com/CycloneDX/cyclonedx-gomod";
    changelog = "https://github.com/CycloneDX/cyclonedx-gomod/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
