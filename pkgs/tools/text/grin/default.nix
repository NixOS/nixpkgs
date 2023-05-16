<<<<<<< HEAD
{ lib, fetchFromGitHub, fetchpatch, python3Packages }:
=======
{ lib, fetchFromGitHub, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "grin";
  version = "1.3.0";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "matthew-brett";
    repo = pname;
    rev = "1.3.0";
<<<<<<< HEAD
    hash = "sha256-exKUy7LaDtpq0rJLSuNYsIcynpB4QLtLIE6T/ncB7RQ=";
  };

  patches = [
    # https://github.com/matthew-brett/grin/pull/4
    (fetchpatch {
      name = "replace-nose-with-nose3.patch";
      url = "https://github.com/matthew-brett/grin/commit/ba473fa4f5da1b337ee80d7d31772a4e41ffa62d.patch";
      hash = "sha256-CnWHynKSsXYjSsTLdPuwpcIndrCdq3cQYS8teg5EM0A=";
    })
  ];

  nativeCheckInputs = with python3Packages; [
    nose3
  ];
=======
    sha256 = "057d05vzx4sf415vnh3qj2g351xhb3illjxjs9mdl3nsnb5r84kv";
  };

  buildInputs = with python3Packages; [ nose ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    homepage = "https://github.com/matthew-brett/grin";
    description = "A grep program configured the way I like it";
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.sjagoe ];
  };
}
