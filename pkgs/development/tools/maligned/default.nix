{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "maligned-unstable";
  version = "2018-07-07";
  rev = "6e39bd26a8c8b58c5a22129593044655a9e25959";

  goPackagePath = "github.com/mdempsky/maligned";

  src = fetchFromGitHub {
    inherit rev;

    owner = "mdempsky";
    repo = "maligned";
    sha256 = "08inr5xjqv9flrlyhqd8ck1q26y5xb6iilz0xkb6bqa4dl5ialhi";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Tool to detect Go structs that would take less memory if their fields were sorted.";
    homepage = "https://github.com/mdempsky/maligned";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
