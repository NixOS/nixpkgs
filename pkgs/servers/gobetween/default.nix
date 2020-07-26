{ buildGoModule, fetchFromGitHub, lib, enableStatic ? false }:

buildGoModule rec {
  pname = "gobetween";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "yyyar";
    repo = "gobetween";
    rev = version;
    sha256 = "0bxf89l53sqan9qq23rwawjkcanv9p61sw56zjqhyx78f0bh0zbc";
  };

  deleteVendor = true;

  buildPhase = ''
    make -e build${lib.optionalString enableStatic "-static"}
  '';

  lxd = fetchFromGitHub {
    owner = "lxc";
    repo = "lxd";
    rev = "814c96fcec7478c9cac9582fead011b2dee0af5b";
    sha256 = "03k2mwkfzgqmgzgxw46mymgkidbjlfv70pzw8hlyi18ag8jj4g5j";
  };

  overrideModAttrs = (_: {
      postBuild = ''
      rm -r vendor/github.com/lxc/lxd
      cp -r --reflink=auto ${lxd} vendor/github.com/lxc/lxd
      '';
    });

  vendorSha256 = "1nnz75mv27iwl5z7wa986gs8mhyn10452vini5x90yfx523bg589";

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
