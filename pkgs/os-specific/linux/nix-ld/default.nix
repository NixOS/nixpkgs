{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, nixosTests
}:
let
  libDir = if builtins.elem stdenv.system [ "x86_64-linux" "mips64-linux" "powerpc64le-linux" ]
           then "/lib64"
           else "/lib";
in
stdenv.mkDerivation rec {
  pname = "nix-ld";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "mic92";
    repo = "nix-ld";
    rev = version;
    sha256 = "sha256-DlWU5i/MykqWgB9vstYbECy3e+XagXWCxi+XDJNey0s=";
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

    ldpath=${libDir}/$(basename $(< ${stdenv.cc}/nix-support/dynamic-linker))
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
  };
}
