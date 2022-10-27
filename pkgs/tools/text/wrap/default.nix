{ lib, buildGoModule, fetchFromGitHub, fetchpatch, makeWrapper, courier-prime }:

buildGoModule rec {
  pname = "wrap";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Wraparound";
    repo = "wrap";
    rev = "v${version}";
    sha256 = "0scf7v83p40r9k7k5v41rwiy9yyanfv3jm6jxs9bspxpywgjrk77";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorSha256 = "03q5a5lm8zj1523gxkbc0y6a3mjj1z2h7nrr2qcz8nlghvp4cfaz";

  patches = [
    (fetchpatch {
      name = "courier-prime-variants.patch";
      url = "https://github.com/Wraparound/wrap/commit/b72c280b6eddba9ec7b3507c1f143eb28a85c9c1.patch";
      sha256 = "1d9v0agfd7mgd17k4a8l6vr2kyswyfsyq3933dz56pgs5d3jric5";
    })
  ];

  postInstall = ''
    wrapProgram $out/bin/wrap --prefix XDG_DATA_DIRS : ${courier-prime}/share/
  '';

  meta = with lib; {
    description = "A Fountain export tool with some extras";
    homepage = "https://github.com/Wraparound/wrap";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.austinbutler ];
  };
}
