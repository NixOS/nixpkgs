{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "5.1.2210";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-N0sWTWZJT4hjivTreYfG5VkxiWgTjlH+/9VZD6YKQXY=";
  };

  vendorHash = "sha256-PClKzvpztpry8xsYLfWB/9s/qI5k2m8qHBxkxY0AJqI=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    homepage = "https://murex.rocks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dit7ya kashw2 ];
  };
}
