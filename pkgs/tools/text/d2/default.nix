{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, git
, testers
, d2
}:

buildGoModule rec {
  pname = "d2";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-MF8RqwoMc48JYgNUJTQKHlGl59xyHOALnFL2BWQAl24=";
  };

  vendorHash = "sha256-SocBC/1LrdSQNfcNVa9nnPaq/UvLVIghHlUSJB7ImBk=";
=======
    hash = "sha256-kfpCu79lJUxPvxSKplRziVnDyohY8xnxnO3ZoG2WgEs=";
  };

  vendorHash = "sha256-oPI6FPfBIPKZDLoyGblcG5UcmoFWufZ2NIEClpSIJzU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  excludedPackages = [ "./e2etests" ];

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X oss.terrastruct.com/d2/lib/version.Version=v${version}"
=======
    "-X oss.terrastruct.com/d2/lib/version.Version=${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ci/release/template/man/d2.1
  '';

  nativeCheckInputs = [ git ];

  preCheck = ''
    # See https://github.com/terrastruct/d2/blob/master/docs/CONTRIBUTING.md#running-tests.
    export TESTDATA_ACCEPT=1
  '';

<<<<<<< HEAD
  passthru.tests.version = testers.testVersion {
    package = d2;
    version = "v${version}";
  };
=======
  passthru.tests.version = testers.testVersion { package = d2; };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A modern diagram scripting language that turns text to diagrams";
    homepage = "https://d2lang.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
