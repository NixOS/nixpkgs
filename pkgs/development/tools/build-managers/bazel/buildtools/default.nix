{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazel-buildtools";
<<<<<<< HEAD
  version = "6.3.3";
=======
  version = "6.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-eGX1W3Nc26aw31dWm1hvcUzFh1efL4Vd86dK6Hs2BJc=";
=======
    rev = version;
    hash = "sha256-CqQ8rj45RES3BV7RBfGr/JX9GzjyRuA1sxgKzQx+oE8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-DigTREfI6I48wxRpGp/bfH1NbUZ4E1B5UTQXpI0LY1A=";

  preBuild = ''
    rm -r warn/docs
  '';

  proxyVendor = true;

  doCheck = false;

  excludedPackages = [ "generatetables" ];

  ldflags = [ "-s" "-w" "-X main.buildVersion=${version}" "-X main.buildScmRevision=${src.rev}" ];

  meta = with lib; {
    description = "Tools for working with Google's bazel buildtool. Includes buildifier, buildozer, and unused_deps";
    homepage = "https://github.com/bazelbuild/buildtools";
<<<<<<< HEAD
    changelog = "https://github.com/bazelbuild/buildtools/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers;
      [ elasticdog uri-canva marsam ]
      ++ lib.teams.bazel.members;
  };
}
