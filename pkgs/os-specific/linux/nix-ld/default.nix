{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "nix-ld";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "mic92";
    repo = "nix-ld";
    rev = version;
    hash = "sha256-+z9t7BLugZO1WhyYEq6FI38TMh2EwfgfAv3RDFSjwtc=";
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

    ldpath=/${stdenv.hostPlatform.libDir}/$(basename $(< ${stdenv.cc}/nix-support/dynamic-linker))
    echo "$ldpath" > $out/nix-support/ldpath
    mkdir -p $out/lib/tmpfiles.d/
    cat > $out/lib/tmpfiles.d/nix-ld.conf <<EOF
      L+ $ldpath - - - - $out/libexec/nix-ld
    EOF
  '';

  passthru.tests.nix-ld = nixosTests.nix-ld;

  meta = with lib; {
    description = "Run unpatched dynamic binaries on NixOS";
    homepage = "https://github.com/Mic92/nix-ld";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;

    # 32 bit builds are broken due to a missing #define value:
    # https://github.com/Mic92/nix-ld/issues/64
    broken = stdenv.is32bit;
  };
}
