{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "pet";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${version}";
    sha256 = "03fzvvdmb06kf2zglaf8jkqxqv9h1kl7n586ww61z3n3mmp1x4rd";
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
