{ stdenv, meson, ninja, lib, nixosTests, fetchFromGitHub }:
let
  self = stdenv.mkDerivation {
    name = "nix-ld";
    src = fetchFromGitHub {
      owner = "Mic92";
      repo = "nix-ld";
      rev = "1.0.0";
      sha256 = "sha256-QYPg8wPpq7q5Xd1jW17Lh36iKFSsVkN/gWYoQRv2XoU=";
    };

    doCheck = true;

    nativeBuildInputs = [ meson ninja ];

    mesonFlags = [
      "-Dnix-system=${stdenv.system}"
    ];

    hardeningDisable = [
      "stackprotector"
    ];

    postInstall = ''
      mkdir -p $out/nix-support
      basename $(< ${stdenv.cc}/nix-support/dynamic-linker) > $out/nix-support/ld-name
    '';

    passthru.tests.nix-ld = nixosTests.nix-ld;
    passthru.ldPath = let
      libDir = if stdenv.system == "x86_64-linux" ||
                  stdenv.system == "mips64-linux" ||
                  stdenv.system == "powerpc64le-linux"
               then
                 "/lib64"
               else
                 "/lib";
      ldName = lib.fileContents "${self}/nix-support/ld-name";
    in "${libDir}/${ldName}";

    meta = with lib; {
      description = "Run unpatched dynamic binaries on NixOS";
      homepage = "https://github.com/Mic92/nix-ld";
      license = licenses.mit;
      maintainers = with maintainers; [ mic92 ];
      platforms = platforms.linux;
    };
  };
in self
