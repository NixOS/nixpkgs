{
  lib,
  pkgs,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin rec {
  pname = "fifc";
  version = "0.1.1-unstable-2024-04-07";

  src = fetchFromGitHub {
    owner = "gazorby";
    repo = "fifc";
    rev = "1bc301453f674ed21fac4979c65a9a4cb7f2af61";
    hash = "sha256-14ORfbl18UOB6UszBHx7NKxnLdiJxUG7gzrtt0ZriCg=";
  };

  propagatedUserEnvPkgs = with pkgs; [
    coreutils
    file
    findutils
    fzf
    gawk
    gnused
    less
    man
    pcre
    procps
  ];

  meta = with lib; {
    description = "Fzf powers on top of fish completion engine and allows customizable completion rules";
    homepage = "https://github.com/gazorby/fifc";
    license = licenses.mit;
    maintainers = with maintainers; [ hmajid2301 Zh40Le1ZOOB ];
  };
}
