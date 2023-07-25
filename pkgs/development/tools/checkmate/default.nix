{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XzzN4oIG6E4NsMGl4HzFlgAGhkRieRn+jyA0bT8fcrg=";
  };

  vendorHash = "sha256-D87b/LhHnu8xE0wRdB/wLIuf5NlqrVnKt2WAF29bdZo=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    changelog = "https://github.com/adedayo/checkmate/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
