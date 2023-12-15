{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "stylelint";
  version = "15.10.3";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-k7Ngbd4Z3/JjCK6taynIiNCDTKfqGRrjfR0ePyRFY4w=";
  };

  npmDepsHash = "sha256-tVDhaDeUKzuyJU5ABSOeYgS56BDSJTfjBZdTsuL/7tA=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    homepage = "https://stylelint.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
