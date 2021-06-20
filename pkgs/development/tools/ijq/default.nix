{ buildGoModule, fetchgit, lib, jq, makeWrapper }:

buildGoModule rec {
  pname = "ijq";
  version = "0.3.4";

  src = fetchgit {
    url = "https://git.sr.ht/~gpanders/ijq";
    rev = "v${version}";
    sha256 = "ZKxEK6SPxEC0S5yXSzITPn0HhpJa4Bcf9X8/N+ZZAeA=";
  };

  vendorSha256 = "04KlXE2I8ZVDbyo9tBnFskLB6fo5W5/lPzSpo8KGqUU=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/ijq" \
      --prefix PATH : "${lib.makeBinPath [ jq ]}"
  '';

  meta = with lib; {
    description = "Interactive wrapper for jq";
    homepage = "https://git.sr.ht/~gpanders/ijq";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ justinas ];
  };
}
