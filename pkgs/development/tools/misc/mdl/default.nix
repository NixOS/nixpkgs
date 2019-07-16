{ lib, bundlerApp }:

bundlerApp {
  pname = "mdl";
  gemdir = ./.;
  exes = [ "mdl" ];

  meta = with lib; {
    description = "A tool to check markdown files and flag style issues";
    homepage = https://github.com/markdownlint/markdownlint;
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli manveru ];
    platforms = platforms.all;
  };
}
