{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ferretdb";
<<<<<<< HEAD
  version = "1.9.0";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cDXdTFgSf126BuPG2h0xZFUTCgyg8IVmNySCQyJV4T4=";
=======
    sha256 = "sha256-V06NIjiT+uxN39vGhwvrU4hbrNezWReEtJdbW6BHIzE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    echo v${version} > build/version/version.txt
    echo nixpkgs     > build/version/package.txt
  '';

<<<<<<< HEAD
  vendorHash = "sha256-mzgj5VBggAqCFlLUcNE03B9jFHLKgfTzH6LI9wTe6Io=";
=======
  vendorSha256 = "sha256-/lM98VTQc6glhnpETW9XbxgN2fP6dBexueByFWwv5sk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  CGO_ENABLED = 0;

  subPackages = [ "cmd/ferretdb" ];

  tags = [ "ferretdb_tigris" ];

  # tests in cmd/ferretdb are not production relevant
  doCheck = false;

  # the binary panics if something required wasn't set during compilation
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/ferretdb --version | grep ${version}
  '';

  meta = with lib; {
    description = "A truly Open Source MongoDB alternative";
    homepage = "https://www.ferretdb.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya noisersup julienmalka ];
  };
}
