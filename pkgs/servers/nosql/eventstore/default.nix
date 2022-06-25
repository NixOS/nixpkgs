{ lib, buildDotnetModule, fetchFromGitHub }:

buildDotnetModule rec {
  pname = "EventStore";
  version = "5.0.8";

  src = fetchFromGitHub {
    owner = "EventStore";
    repo = "EventStore";
    rev = "oss-v${version}";
    sha256 = "021m610gzmrp2drywl1q3y6xxpy4qayn580d855ag952z9s6w9nj";
  };

  # that dependency seems to not be required for building, but pulls in libcurl which fails to be located.
  # see: https://github.com/EventStore/EventStore/issues/1897
  postPatch = ''
    for f in $(find . -iname "*.csproj"); do
      sed -i '/Include="Microsoft.SourceLink.GitHub"/d' $f
    done
  '';

  nugetDeps = ./deps.nix;

  projectFile = "src/EventStore.ClusterNode/EventStore.ClusterNode.csproj";

  doCheck = true;
  testProjectFile = "src/EventStore.Projections.Core.Tests/EventStore.Projections.Core.Tests.csproj";

  meta = {
    homepage = "https://geteventstore.com/";
    description = "Event sourcing database with processing logic in JavaScript";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ puffnfresh ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
