{ lib
, buildPythonApplication
, fetchFromGitHub
, gitMinimal
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      click = super.click.overridePythonAttrs (oldAttrs: rec {
        version = "7.1.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "06kbzd6sjfkqan3miwj9wqyddfxc2b6hi7p5s4dvqjb3gif2bdfj";
        };
      });

      arrow = super.arrow.overridePythonAttrs (oldAttrs: rec {
        version = "1.0.3";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0793badh4hgbk2c5g70hmbl7n3d4g5d87bcflld0w9rjwy59r71r";
        };
      });

      sh = super.sh.overridePythonAttrs (oldAttrs: rec {
        version = "1.14.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "13hxgifab9ichla13qaa7sh8r0il7vs1r21js72s0n355zr9mair";
        };
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "gitlint";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "jorisroovers";
    repo = "gitlint";
    rev = "v${version}";
    sha256 = "sha256-CqmE4V+svSuQAsoX0I3NpUqPU5CQf3fyCHJPrjUjHF4=";
  };

  nativeBuildInputs = [
    wheel
  ];

  propagatedBuildInputs = [
    arrow
    click
    sh
  ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  checkInputs = [
    gitMinimal
  ];

  meta = with lib; {
    description = "Linting for your git commit messages";
    homepage = "https://jorisroovers.com/gitlint/";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 fab ];
  };
}
