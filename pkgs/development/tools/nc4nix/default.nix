{ lib
, buildGoModule
, fetchFromGitHub
, nix
, makeWrapper
, fetchpatch
}:

buildGoModule rec {
  pname = "nc4nix";
  version = "unstable-2023-06-06";

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "nc4nix";
    rev = "3e015450726533770fd00e2771530cbe90f40517";
    sha256 = "sha256-i3lx5Q+EswtimdRMZ0OPMWh01kBK9q+UI1pY6j/ZhuY=";
  };

  patches = [
    # Switch hash calculation method
    # https://github.com/helsinki-systems/nc4nix/pull/3
    (fetchpatch {
      url = "https://github.com/helsinki-systems/nc4nix/commit/a7bca4793cc12e87d381f12f6f8c00ae2ca02893.patch";
      sha256 = "sha256-0JxyhSQLtlgLtsMv82wMjQHGdmOoQ2dcPPNAw2cFByE=";
      name = "switch_hash_calculation_method.patch";
    })
  ];

  vendorSha256 = "sha256-uhINWxFny/OY7M2vV3ehFzP90J6Z8cn5IZHWOuEg91M=";

 nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    # Depends on nix-prefetch-url
    wrapProgram $out/bin/nc4nix \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  meta = with lib; {
    description = "Packaging helper for Nextcloud apps";
    homepage = "https://github.com/helsinki-systems/nc4nix";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}

