{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
, pkg-config
, btrfs-progs
, gpgme
, lvm2
}:

buildGoModule rec {
  pname = "dive";
<<<<<<< HEAD
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = "dive";
    rev = "v${version}";
    hash = "sha256-9REthyb+bzsb7NBXkU9XyUZJFQHHrV1cG4//lTLgTgw=";
  };

  patches = [
    # fixes: unsafe.Slice requires go1.17 or later (-lang was set to go1.16; check go.mod)
    # https://github.com/wagoodman/dive/pull/461
    (fetchpatch {
      url = "https://github.com/wagoodman/dive/commit/555555d777f961ad0a2d1bb843e87f434d731dba.patch";
      hash = "sha256-tPSgvENiVgrlQSkT7LbQPRYhkkaYQeWRJ0P4bA3XOiI=";
    })
  ];

  vendorHash = "sha256-6KIbTrkvdugsUKdFBqtPUFzs/6h2xslLFpr6S2nSBiY=";
=======
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1pmw8pUlek5FlI1oAuvLSqDow7hw5rw86DRDZ7pFAmA=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/wagoodman/dive/commit/fe9411c414418d839a8638bb9a12ccfc892b5845.patch";
      sha256 = "sha256-c0TcUQ87CeOiXHoTQ3z/04i72aDr403DL7fIbXTJ9cY=";
    })
  ];

  vendorSha256 = "sha256-YPkEei7d7mXP+5FhooNoMDARQLosH2fdSaLXGZ5C27o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ btrfs-progs gpgme lvm2 ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for exploring each layer in a docker image";
    homepage = "https://github.com/wagoodman/dive";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ marsam SuperSandro2000 ];
=======
    maintainers = with maintainers; [ marsam spacekookie SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
