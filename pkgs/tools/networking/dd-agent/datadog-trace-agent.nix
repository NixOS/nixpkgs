{ buildGoPackage, fetchFromGitHub, go, rake, git, writeText }:

let version = "5.12.3";
in
buildGoPackage {
  name = "datadog-trace-agent";
  src = fetchFromGitHub {
    owner = "datadog";
    repo = "datadog-trace-agent";
    rev = version;
    sha256 = "14qjkzmcvismzm9xkc8wns05c6986agxyiddvpn2dh0af60llx1z";
  };
  goPackagePath = "github.com/DataDog/datadog-trace-agent";
  goDeps = ./trace-deps.nix;
}
