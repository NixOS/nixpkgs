{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotypist";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "pb-";
    repo = "gotypist";
    rev = "${version}";
    sha256 = "0khl2f6bl121slw9mlf4qzsdarpk1v3vry11f3dvz7pb1q6zjj11";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "A touch-typing tutor";
    longDescription = ''
      A simple touch-typing tutor that follows Steve Yegge's methodology of
      going in fast, slow, and medium cycles.
    '';
    homepage = "https://github.com/pb-/gotypist";
    license = licenses.mit;
    maintainers = with maintainers; [ pb- ];
  };
}
