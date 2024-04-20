{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hclfmt";
  version = "2.20.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcl";
    rev = "v${version}";
    hash = "sha256-+4K6k32azx/66eag9c6lUN8TUJ1ICx4Q8zpnTJWqgQ0=";
  };

  vendorHash = "sha256-L5OabeDUXbrwFOgWRhi9FPTWK+xbL54ZM7cYhS15Jis=";

  # The code repository includes other tools which are not useful. Only build
  # hclfmt.
  subPackages = [ "cmd/hclfmt" ];

  meta = with lib; {
    description = "a code formatter for the Hashicorp Configuration Language (HCL) format";
    homepage = "https://github.com/hashicorp/hcl/tree/main/cmd/hclfmt";
    license = licenses.mpl20;
    mainProgram = "hclfmt";
    maintainers = with maintainers; [ zimbatm ];
  };
}
