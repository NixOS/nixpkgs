{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  src = fetchFromGitHub {
    owner = "teto";
    repo = "luarocks";
    rev = "f9dc7892214bff6bce822d94aca3331048e61df0";
    sha256 = "117qqbiv87p2qw0zwapl7b0p4wgnn9f8k0qpppkj3653a1bwli05";
  };
})
