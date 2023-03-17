{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "grin";
  version = "1.3.0";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "matthew-brett";
    repo = pname;
    rev = "1.3.0";
    sha256 = "057d05vzx4sf415vnh3qj2g351xhb3illjxjs9mdl3nsnb5r84kv";
  };

  buildInputs = with python3Packages; [ nose ];

  meta = {
    homepage = "https://github.com/matthew-brett/grin";
    description = "A grep program configured the way I like it";
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.sjagoe ];
  };
}
