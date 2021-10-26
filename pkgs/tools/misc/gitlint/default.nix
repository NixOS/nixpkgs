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
        version = "8.0.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0ymdyf37acq4qxh038q0xx44qgj6y2kf0jd0ivvix6qij88w214c";
        };
      });

      arrow = super.arrow.overridePythonAttrs (oldAttrs: rec {
        version = "1.2.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0x70a057dqki2z1ny491ixbg980hg4lihc7g1zmy69g4v6xjkz0n";
        };
      });

    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "gitlint";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "jorisroovers";
    repo = "gitlint";
    rev = "v${version}";
    sha256 = "1j6gfgqin5dmqd2qq0vib55d2r07s9sy4hwrvwlichxx5jjwncly";
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
