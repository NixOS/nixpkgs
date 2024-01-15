{ lib, fetchFromGitHub, perlPackages }:

perlPackages.buildPerlPackage rec {
  pname = "rename";
  version = "1.11";
  outputs = [ "out" ];
  src = fetchFromGitHub {
    owner = "pstray";
    repo = "rename";
    rev = "v${version}";
    sha256 = "SK6wS3IxjCftuDiiZU27TFnn9GVd137zmzvGH88cNLI=";
  };
  meta = with lib; {
    description = "Rename files according to a Perl rewrite expression";
    homepage = "https://github.com/pstray/rename";
    maintainers = with maintainers; [ mkg cyplo ];
    license = with licenses; [ gpl1Plus ];
    mainProgram = "rename";
  };
}
