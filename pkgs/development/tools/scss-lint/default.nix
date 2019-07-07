{ lib, bundlerApp }:

bundlerApp {
  pname = "scss_lint";
  gemdir = ./.;
  exes = [ "scss-lint" ];

  meta = with lib; {
    description = "A tool to help keep your SCSS files clean and readable";
    homepage    = https://github.com/brigade/scss-lint;
    license     = licenses.mit;
    maintainers = [ maintainers.lovek323 ];
    platforms   = platforms.unix;
  };
}
