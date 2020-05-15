{ lib, fetchFromGitHub, buildGoPackage }:

with lib;

buildGoPackage rec {
  pname = "ct";
  version = "0.7.0";

  goPackagePath = "github.com/coreos/container-linux-config-transpiler";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "container-linux-config-transpiler";
    rev = "v${version}";
    sha256="058zjk9yqgdli55gc6y48455il6wjpslyz2r2ckk2ki9c5qc8b7c";
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

