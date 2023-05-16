{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "snowcrash";
<<<<<<< HEAD
  version = "unstable-2022-08-15";
=======
  version = "unstable-2021-04-29";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "redcode-labs";
    repo = "SNOWCRASH";
<<<<<<< HEAD
    rev = "32e62f9ff7d3dda9fac8acfc56176f1f2a70d066";
    hash = "sha256-mURF/VUqygd5bLJdmbwnZq003IXJKn+k8HtS+CxoQJQ=";
  };

  vendorHash = "sha256-WTDE+MYL8CjeNvGHRNiMgBFrydDJWIcG8TYvbQTH/6o=";
=======
    rev = "514cceea1ca82f44e0c8a8744280f3a16abb6745";
    sha256 = "sha256-jQrd7sluDd9eC4VdNtxvGct7Y4Y3zOylc4y2n6Kz4Zo=";
  };

  patches = [
    (fetchpatch {
      name = "update-x-sys-for-go-1.18-on-aarch64-darwin.patch";
      url = "https://github.com/redcode-labs/SNOWCRASH/commit/24eefdcc944ade0cf435f7f35dee59ef3f0497fd.patch";
      sha256 = "sha256-UXk7cMyEVAVcOkELcC9TlQNppZOXIvn6DBYu1j2iVNg=";
    })
  ];

  vendorSha256 = "sha256-WTDE+MYL8CjeNvGHRNiMgBFrydDJWIcG8TYvbQTH/6o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  postFixup = lib.optionals (!stdenv.isDarwin) ''
    mv $out/bin/SNOWCRASH $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Polyglot payload generator";
    homepage = "https://github.com/redcode-labs/SNOWCRASH";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ] ++ teams.redcodelabs.members;
    mainProgram = "SNOWCRASH";
  };
}
