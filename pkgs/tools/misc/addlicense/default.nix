{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "addlicense";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "addlicense";
    rev = "v${version}";
    sha256 = "sha256-YMMHj6wctKtJi/rrcMIrLmNw/uvO6wCwokgYRQxcsFw=";
  };

  patches = [
    # Add support for Nix files. Upstream is slow with responding to PRs,
    # patch backported from PR https://github.com/google/addlicense/pull/153.
    (fetchpatch {
      url = "https://github.com/google/addlicense/commit/e0fb3f44cc7670dcc5cbcec2211c9ad238c5f9f1.patch";
      hash = "sha256-XCAvL+HEa1hGc0GAnl+oYHKzBJ3I5ArS86vgABrP/Js=";
    })
  ];

  vendorHash = "sha256-2mncc21ecpv17Xp8PA9GIodoaCxNBacbbya/shU8T9Y=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Ensures source code files have copyright license headers by scanning directory patterns recursively";
    homepage = "https://github.com/google/addlicense";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "addlicense";
  };
}
