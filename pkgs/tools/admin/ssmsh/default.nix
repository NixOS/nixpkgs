{ lib, buildGoModule, fetchFromGitHub, updateGolangSysHook }:

buildGoModule rec {
  pname = "ssmsh";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "bwhaley";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-juyTCtcuFIlKyLxDrK5tRRzCMwoSXG4EUA32E/Z4y5c=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-fzYVP8ita/ZZV9gUt9ptndO0+7ugWZOaCMace2Wsw1w=";

  doCheck = true;

  ldflags = [ "-w" "-s" "-X main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/bwhaley/ssmsh";
    description = "An interactive shell for AWS Parameter Store";
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
  };
}
