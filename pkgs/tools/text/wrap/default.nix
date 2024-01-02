{ lib, buildGoModule, fetchFromGitHub, fetchpatch, makeWrapper, courier-prime }:

buildGoModule rec {
  pname = "wrap";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Wraparound";
    repo = "wrap";
    rev = "v${version}";
    hash = "sha256-58wsH/e3X72S7tJUObazyvvkI8+B7DLPTBmQO9A+jmk=";
  };

  vendorHash = "sha256-vg61Vypd+mSF9FyLFVpnS5UCTJDoobkDE1Cneg8O0RM=";

  nativeBuildInputs = [ makeWrapper ];

  patches = [
    (fetchpatch {
      name = "courier-prime-variants.patch";
      url = "https://github.com/Wraparound/wrap/commit/b72c280b6eddba9ec7b3507c1f143eb28a85c9c1.patch";
      hash = "sha256-hcUsRyv6XVN+GyMN7LXzXPsp8jYUKTJPaK+e5p4CO7U=";
    })
    # Fix build on Go 1.17+
    (fetchpatch {
      url = "https://github.com/Wraparound/wrap/commit/a222c18a7e0810486741684781ff6158a359a8ba.patch";
      hash = "sha256-eIKvA91olfbNJhOhIUu3GOL/rbgX3m6unmU8nRdKbtc=";
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
