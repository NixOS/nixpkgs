{ rsync, buildGoModule, fetchFromGitHub, lib, runCommand, enableStatic ? false }:

buildGoModule rec {
  pname = "gobetween";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "yyyar";
    repo = "gobetween";
    rev = version;
    sha256 = "f01593509ccece063acd47002c4fc52261fbbbcdbf14b088d813b7d8e38fcca8";
  };
  patches = [ ./gomod.patch ];

  deleteVendor = true;

  buildPhase = ''
    make -e build${lib.optionalString enableStatic "-static"}
  '';

  lxd = fetchFromGitHub {
    owner = "lxc";
    repo = "lxd";
    rev = "41efd98813f3b42f1752ff6c2c7569a054924623";
    sha256 = "02vnvjjkzl7b0i2cn03f1lb3jgj5rd3wdkii4pqi9bvmhzszg0l2";
  };

  overrideModAttrs = (_: {
      postBuild = ''
      rm -r vendor/github.com/lxc/lxd
      cp -r --reflink=auto ${lxd} vendor/github.com/lxc/lxd
      '';
    });

  vendorSha256 = "1pd0zrjwpw6yv2s86a818yy2ma2fkazd3sb2h6zfp9mvyixgxgri";

  installPhase = ''
    mkdir -p $out/bin
    cp bin/gobetween $out/bin
    cp -r share $out/share
    cp -r config $out/share
  '';

  meta = with lib; {
    description = "Modern & minimalistic load balancer for the Сloud era";
    homepage = "http://gobetween.io";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
  };
}
