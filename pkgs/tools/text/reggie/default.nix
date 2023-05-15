{ lib, fetchFromGitHub, buildDotnetModule, dotnetCorePackages }:

buildDotnetModule rec {
  pname = "reggie";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "yellowsink";
    repo = "reggie";
    rev = "v${version}";
    sha256 = "SYFOgOUFdCGaKMMt5mjV/EfQVn7TvxtcCHqoWq9Psus=";
  };

  projectFile = "Reggie.sln";
  nugetDeps = ./deps.nix;

  dotnetFlags = "-p:PublishSingleFile=false -p:PublishTrimmed=false -p:AssemblyName=reggie";

  meta = with lib; {
    description = "Painless regex from the CLI, as an alternative to sed";
    homepage = "https://github.com/yellowsink/reggie";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.yellowsink ];
  };
}
