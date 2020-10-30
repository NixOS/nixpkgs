{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "pack";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h7lgsg5d74pfa15kx0y3ngnvmz64znqk2k73iyjya9pi9h8hh88";
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
