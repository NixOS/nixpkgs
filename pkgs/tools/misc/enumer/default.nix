{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "enumer";
  version = "1.5.9";

  src = fetchFromGitHub {
    owner = "dmarkham";
    repo = "enumer";
    rev = "refs/tags/v${version}";
    hash = "sha256-NYL36GBogFM48IgIWhFa1OLZNUeEi0ppS6KXybnPQks=";
  };

  vendorHash = "sha256-CJCay24FlzDmLjfZ1VBxih0f+bgBNu+Xn57QgWT13TA=";

  meta = with lib; {
    description = "Go tool to auto generate methods for enums";
    homepage = "https://github.com/dmarkham/enumer";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "enumer";
  };
}
