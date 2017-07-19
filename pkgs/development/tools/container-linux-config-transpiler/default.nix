{ stdenv, lib, fetchFromGitHub, buildGoPackage }:

with lib;

buildGoPackage rec {
  name = "ct-${version}";
  version = "0.4.1";

  goPackagePath = "github.com/coreos/container-linux-config-transpiler";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "container-linux-config-transpiler";
    rev = "v${version}";
    sha256="1017xkinja30jcam8p1x2d9q4vkgkfn7gvkad004jkbbmd2216sa";
  };

  buildFlagsArray = ''
    -ldflags=-X ${goPackagePath}/internal/version.Raw=v${version}
  '';

  postInstall = ''
    mv $bin/bin/{internal,ct}
    rm $bin/bin/tools
  '';

  meta = {
    description = "Convert a Container Linux Config into Ignition";
    license = licenses.asl20;
    homepage = https://github.com/coreos/container-linux-config-transpiler;
    maintainers = with maintainers; [elijahcaine];
    platforms = with platforms; unix;
  };
}

