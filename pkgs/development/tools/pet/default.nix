{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "pet";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${version}";
    sha256 = "1na3az7vicjq1rxd3ybid47yrblsdazgli0dchkbwh8zchwhqj33";
  };

  modSha256 = "06ham8lsx5c1vk5jkwp1aa9g4q4g7sfq7gxz2gkffa98x2vlawyf";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    homepage = https://github.com/knqyf263/pet;
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
