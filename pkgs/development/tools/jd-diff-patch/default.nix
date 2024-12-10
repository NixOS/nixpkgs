{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jd-diff-patch";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "josephburnett";
    repo = "jd";
    rev = "v${version}";
    sha256 = "sha256-fi+vj1vHhgw2OPQqQ0827P6Axy/cio0UVFLeD/nhFvw=";
  };

  # not including web ui
  excludedPackages = [
    "gae"
    "pack"
  ];

  vendorHash = null;

  meta = with lib; {
    description = "Commandline utility and Go library for diffing and patching JSON values";
    homepage = "https://github.com/josephburnett/jd";
    license = licenses.mit;
    maintainers = with maintainers; [
      bryanasdev000
      blaggacao
    ];
    mainProgram = "jd";
  };
}
