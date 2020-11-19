{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "pack";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m2hcd7fdvlqy8yp3pa2ccpk9wbnknjh2f8qic31v9yh3zm8aga7";
  };

  vendorSha256 = "1c38g169kq9kv6x0x1rlg39ywbc1q66fndby0v85b3ri3xb52869";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/pack" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/buildpacks/pack.Version=${version}" ];

  postInstall = ''
    installShellCompletion --bash --name pack.bash $(PACK_HOME=$PWD $out/bin/pack completion --shell bash)
    installShellCompletion --zsh --name _pack $(PACK_HOME=$PWD $out/bin/pack completion --shell zsh)
  '';

  meta = with lib; {
    homepage = "https://buildpacks.io/";
    changelog = "https://github.com/buildpacks/pack/releases/tag/v${version}";
    description = "CLI for building apps using Cloud Native Buildpacks";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
