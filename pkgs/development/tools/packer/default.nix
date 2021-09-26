{ lib, buildGoModule, fetchFromGitHub, installShellFiles, fetchpatch }:

buildGoModule rec {
  pname = "packer";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "15kw4zy0p7hr6jm0202s0fk5ja3ff0pdir37qdifngm1x7id1vxc";
  };

  vendorSha256 = "1785yv48sn504zcig9szjw9s4dxb55dg9idh10i2gzfgbda2c3nf";

  patches = [
    # https://github.com/hashicorp/packer/pull/11282
    (fetchpatch {
      url = "https://github.com/hashicorp/packer/commit/dbf13803217e18c6cb567ffefc9476c4e0149e02.patch";
      sha256 = "1n038x6qnr75c5ci2jp8jcwp6yvlchcf2nydksb2s75ffvidjrsa";
    })
  ];

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh contrib/zsh-completion/_packer
  '';

  meta = with lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = "https://www.packer.io";
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ma27 ];
    changelog   = "https://github.com/hashicorp/packer/blob/v${version}/CHANGELOG.md";
    platforms   = platforms.unix;
  };
}
