{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "cod-unstable";
  version = "2020-09-10";

  goPackagePath = "cod";

  src = fetchFromGitHub {
    owner = "dim-an";
    repo = "cod";
    rev = "ae68da08339471dd278d6df79abbfd6fe89a10fe";
    sha256 = "1l3gn9v8dcy72f5xq9hwbkvkis0vp4dp8qyinsrii3acmhksg9v6";
  };

  vendorSha256 = "1arllkiz1hk12hq5b2zpg3f8i9lxl66mil5sdv8gnhflmb37vbv3";

  buildFlagsArray = [ "-ldflags=-X main.GitSha=${src.rev}" ];

  doCheck = false;

  meta = with lib; {
    description = "Tool for generating Bash/Zsh autocompletions based on `--help` output";
    homepage = src.meta.homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
