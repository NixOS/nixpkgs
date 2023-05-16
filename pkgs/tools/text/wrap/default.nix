{ lib, buildGoModule, fetchFromGitHub, fetchpatch, makeWrapper, courier-prime }:

buildGoModule rec {
  pname = "wrap";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Wraparound";
    repo = "wrap";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-58wsH/e3X72S7tJUObazyvvkI8+B7DLPTBmQO9A+jmk=";
  };

  vendorHash = "sha256-vg61Vypd+mSF9FyLFVpnS5UCTJDoobkDE1Cneg8O0RM=";

  nativeBuildInputs = [ makeWrapper ];

=======
    sha256 = "0scf7v83p40r9k7k5v41rwiy9yyanfv3jm6jxs9bspxpywgjrk77";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorSha256 = null; #vendorSha256 = "";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  patches = [
    (fetchpatch {
      name = "courier-prime-variants.patch";
      url = "https://github.com/Wraparound/wrap/commit/b72c280b6eddba9ec7b3507c1f143eb28a85c9c1.patch";
<<<<<<< HEAD
      hash = "sha256-hcUsRyv6XVN+GyMN7LXzXPsp8jYUKTJPaK+e5p4CO7U=";
    })
    # Fix build on Go 1.17+
    (fetchpatch {
      url = "https://github.com/Wraparound/wrap/commit/a222c18a7e0810486741684781ff6158a359a8ba.patch";
      hash = "sha256-eIKvA91olfbNJhOhIUu3GOL/rbgX3m6unmU8nRdKbtc=";
=======
      sha256 = "1d9v0agfd7mgd17k4a8l6vr2kyswyfsyq3933dz56pgs5d3jric5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    broken = true; # vendor isn't reproducible with go > 1.17: nix-build -A $name.go-modules --check
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
