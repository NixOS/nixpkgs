{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "BitTornado";
  version = "unstable-2018-02-09";

  src = fetchFromGitHub {
    owner = "effigies";
    repo = "BitTornado";
    rev = "a3e6d8bcdf9d99de064dc58b4a3e909e0349e589";
    sha256 = "099bci3as592psf8ymmz225qyz2lbjhya7g50cb7hk64k92mqk9k";
  };

  postFixup = ''
    for i in $(ls $out/bin); do		
      mv $out/bin/$i $out/bin/''${i%.py}
    done
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "John Hoffman's fork of the original bittorrent";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
