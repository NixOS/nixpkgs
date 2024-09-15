{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, pkg-config
, libusb1
}:

buildGoModule rec {
  pname = "go-ios";
  version = "1.0.143";

  src = fetchFromGitHub {
    owner = "danielpaulus";
    repo = "go-ios";
    rev = "v${version}";
    sha256 = "sha256-6RiKyhV5y6lOrhfZezSB2m/l17T3bHYaYRhsMf04wT8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-GfVHAOlN2tL21ILQYPw/IaYQZccxitjHGQ09unfHcKg=";

  excludedPackages = [
    "restapi"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  postInstall = ''
    # aligns the binary with what is expected from go-ios
    mv $out/bin/go-ios $out/bin/ios
  '';

  # skips all the integration tests (requires iOS device) (`-tags=fast`)
  # as well as tests that requires networking
  checkFlags = let
    skippedTests = [
      "TestWorksWithoutProxy"
      "TestUsesProxy"
    ];
  in [ "-tags=fast" ]
  ++ [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Operating system independent implementation of iOS device features";
    homepage = "https://github.com/danielpaulus/go-ios";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
    mainProgram = "ios";
  };
}
