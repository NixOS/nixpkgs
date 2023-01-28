{ lib, stdenv, perl, fetchFromGitHub, fetchpatch, nix-update-script, testers, cowsay }:

stdenv.mkDerivation rec {
  pname = "cowsay";
  version = "3.7.0";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "cowsay-org";
    repo = "cowsay";
    rev = "v${version}";
    hash = "sha256-t1grmCPQhRgwS64RjEwkK61F2qxxMBKuv0/DzBTnL3s=";
  };

  patches = [
    # Install cowthink as a symlink, not a copy
    # See https://github.com/cowsay-org/cowsay/pull/18
    (fetchpatch {
      url = "https://github.com/cowsay-org/cowsay/commit/9e129fa0933cf1837672c97f5ae5ad4a1a10ec11.patch";
      hash = "sha256-zAYEUAM5MkyMONAl5BXj8hBHRalQVAOdpxgiM+Ewmlw=";
    })
  ];

  buildInputs = [ perl ];

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = cowsay;
      command = "cowsay --version";
    };
  };

  meta = with lib; {
    description = "A program which generates ASCII pictures of a cow with a message";
    homepage = "https://cowsay.diamonds";
    changelog = "https://github.com/cowsay-org/cowsay/releases/tag/v${version}";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ rob anthonyroussel ];
  };
}
