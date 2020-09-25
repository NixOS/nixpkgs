{ lib, fetchFromGitHub, buildGoPackage }:

with lib;

buildGoPackage rec {
  pname = "ct";
  version = "0.9.0";

  goPackagePath = "github.com/coreos/container-linux-config-transpiler";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "container-linux-config-transpiler";
    rev = "v${version}";
    sha256="1w6nvgrl5qp3ci9igflk9dlk3020psv5m4f3p57f3qcx9vrcl4lw";
  };

  buildFlagsArray = ''
    -ldflags=-X ${goPackagePath}/internal/version.Raw=v${version}
  '';

  postInstall = ''
    mv $out/bin/{internal,ct}
    rm $out/bin/tools
  '';

  meta = {
    description = "Convert a Container Linux Config into Ignition";
    license = licenses.asl20;
    homepage = "https://github.com/coreos/container-linux-config-transpiler";
    maintainers = with maintainers; [elijahcaine];
    platforms = with platforms; unix;
  };
}

