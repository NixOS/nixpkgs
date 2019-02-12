{ lib, bundlerEnv, ruby }:

bundlerEnv {
  inherit ruby;
  pname = "mdl";
  gemdir = ./.;

  meta = with lib; {
    description = "A tool to check markdown files and flag style issues";
    homepage = https://github.com/markdownlint/markdownlint;
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
