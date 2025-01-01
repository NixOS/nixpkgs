{
  lib,
  buildTypstPackage,
  fetchFromGitHub,
}:

buildTypstPackage rec {
  pname = "polylux";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "andreasKroepelin";
    repo = "polylux";
    tag = "v${version}";
    hash = "sha256-jErxl2s2xez2huUwpsT6N1pZANvuZMdIt4taFOurCtU=";
  };

  meta = {
    homepage = "https://github.com/andreasKroepelin/polylux";
    description = "A package for creating slides in Typst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cherrypiejam ];
  };
}
