{ buildDotnetModule, lib, fetchFromGitHub, dotnetCorePackages }:

buildDotnetModule rec {
  pname = "BaGet";
  version = "0.4.0-preview2";

  src = fetchFromGitHub {
    owner = "loic-sharma";
    repo = pname;
    rev = "v${version}";
    sha256 = "S/3CjXB/fBDzxLuQBQB3CKgEkmzUA8ZzzvzXLN8hfBU=";
  };

  postPatch = ''
    # this fixes NU1605 errors
    substituteInPlace \
      src/BaGet.Azure/BaGet.Azure.csproj \
      --replace \
      'Include="Microsoft.Azure.Cosmos.Table" Version="1.0.0"' \
      'Include="Microsoft.Azure.Cosmos.Table" Version="2.0.0-preview"'
  '';

  projectFile = "src/BaGet/BaGet.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_3_1;
  dotnet-runtime = dotnetCorePackages.aspnetcore_3_1;

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    description = "A lightweight NuGet and symbol server";
    license = licenses.mit;
    homepage = "https://loic-sharma.github.io/BaGet/";
    maintainers = [ maintainers.abbradar ];
  };
}
