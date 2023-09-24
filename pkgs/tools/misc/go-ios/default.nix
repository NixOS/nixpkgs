{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "go-ios";
  version = "1.0.115";

  src = fetchFromGitHub {
    owner = "danielpaulus";
    repo = "go-ios";
    rev = "v${version}";
    sha256 = "sha256-pvgdGBLgRHvnGdAyA4Rrexkh5oRzVT7AYgKfLNfSf7M=";
  };

  vendorHash = "sha256-lLpvpT0QVVyy12HmtOQxagT0JNwRO7CcfkGhCpouH8w=";

  excludedPackages = [
    "restapi"
  ];

  checkFlags = [
    "-tags=fast"
  ];

  postInstall = ''
    # aligns the binary with what is expected from go-ios
    mv $out/bin/go-ios $out/bin/ios
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "An operating system independent implementation of iOS device features";
    homepage = "https://github.com/danielpaulus/go-ios";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
