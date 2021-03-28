{ buildGoModule, fetchgit, lib, jq, makeWrapper }:

buildGoModule rec {
  pname = "ijq";
  version = "0.2.3";

  src = fetchgit {
    url = "https://git.sr.ht/~gpanders/ijq";
    rev = "v${version}";
    sha256 = "14n54jh5387jf97zhc7aidn7w60zp5624xbvq4jdbsh96apg3bk1";
  };

  vendorSha256 = "0xbni6lk6y3ig7pj2234fv7ra6b8qv0k8m3bvh59wwans8xpihzb";

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
