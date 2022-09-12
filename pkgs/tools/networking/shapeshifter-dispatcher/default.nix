{ lib, buildGoModule, fetchFromGitHub, fetchpatch, ... }:

buildGoModule rec {
  pname = "shapeshifter-dispatcher";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "OperatorFoundation";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QhPlg0Jh1V9Zea5uo6lUqj/8yhNW/i9m4muaFKn8IZs=";
  };

  patches = [
    # go.mod and go.sum files
    (fetchpatch {
      url =
        "https://github.com/OperatorFoundation/shapeshifter-dispatcher/commit/b936dc8004db276a5b639bbe6377895284e8d8c9.patch";
      sha256 = "sha256-4fJFdY4xYN1ZBOseDidOieGiOpFAabZRyM8icBpkITI=";
    })
  ];

  vendorSha256 = "sha256-D1Og94NKf7PG+BJ3ieaZsKzEDo/i6Bx+FjNnAT47g+k=";

  doCheck = false;

  meta = with lib; {
    description =
      "The Shapeshifter project provides network protocol shapeshifting technology (also sometimes referred to as obfuscation).";
    homepage = "https://github.com/OperatorFoundation/shapeshifter-dispatcher";
    license = licenses.mit;
    maintainers = with maintainers; [ kurnevsky ];
  };
}
