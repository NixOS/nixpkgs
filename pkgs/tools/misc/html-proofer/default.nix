{ bundlerEnv, ruby, lib }:

bundlerEnv rec {
  name = "${pname}-${version}";
  pname = "html-proofer";
  version = (import ./gemset.nix).html-proofer.version;

  inherit ruby;
  gemdir = ./.;

  meta = with lib; {
    description = "A tool to validate HTML files";
    homepage    = https://github.com/gjtorikian/html-proofer;
    license     = licenses.mit;
    maintainers = with maintainers; [ primeos ];
    platforms   = platforms.unix;
  };
}
