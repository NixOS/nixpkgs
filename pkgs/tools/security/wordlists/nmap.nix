{ fetchFromGitHub
, lib
, nmap
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "nmap";
  version = "unstable-2020-10-19";

  src = fetchFromGitHub
    {
      owner = "nmap";
      repo = "nmap";
      rev = "0b49f7f933577a1904f232bfc2d347553ed22860";
      sha256 = "sha256-rA6cd9K2uX8EfByTJ2u2/48U4SqD9IGs+3CLlfgxHE0=";
    } + "/nselib/data/passwords.lst";

  dontUnpack = true;

  installPhase = ''
    install -m 444 -D $src $out/share/nmap.lst
  '';

  meta = with lib; {
    inherit (nmap.meta) homepage license;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
