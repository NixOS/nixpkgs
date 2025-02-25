{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  makeWrapper,
}:

buildGoModule rec {
  pname = "trufflehog";
  version = "3.88.12";

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    tag = "v${version}";
    hash = "sha256-7ibN9j3UR6os3YK64W1AXPIvQUgsadIQhxgcBajya7Q=";
  };

  vendorHash = "sha256-nMEvAH12hXQ/t9eFDEY3oTFT27swTKPnlY9ilQUdUbg=";

  nativeBuildInputs = [ makeWrapper ];

  proxyVendor = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=${version}"
  ];

  # Test cases run git clone and require network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/{generate,snifftest}

    wrapProgram $out/bin/trufflehog --add-flags --no-update
  '';

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  meta = with lib; {
    description = "Find credentials all over the place";
    homepage = "https://github.com/trufflesecurity/trufflehog";
    changelog = "https://github.com/trufflesecurity/trufflehog/releases/tag/v${version}";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [
      fab
      sarcasticadmin
    ];
  };
}
