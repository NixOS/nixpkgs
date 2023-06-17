{ lib
, buildGoModule
, fetchFromGitHub
, nix
, makeWrapper
, fetchpatch
}:

buildGoModule rec {
  pname = "nc4nix";
  version = "unstable-2023-05-25";

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "nc4nix";
    rev = "14cab9b2f8628ae6668c1d01519f558069f7f675";
    sha256 = "sha256-iy9jJMRu0SkfrDufO6WAObqdiusvwhyv+GGHVrD3CV4=";
  };

  patches = [
    # Switch hash calculation method
    # https://github.com/helsinki-systems/nc4nix/pull/3
    (fetchpatch {
      url = "https://github.com/helsinki-systems/nc4nix/commit/88c182fbdddef148e086fa86438dcd72208efd75.patch";
      sha256 = "sha256-zAF0+t9wHrKhhyD0+/d58BiaavLHfxO8X5J6vNlEWx0=";
      name = "switch_hash_calculation_method.patch";
    })
     # Add package selection command line argument
     # https://github.com/helsinki-systems/nc4nix/pull/2
    (fetchpatch {
      url = "https://github.com/helsinki-systems/nc4nix/pull/2/commits/449eec89538df4e92106d06046831202eb84a1db.patch";
      sha256 = "sha256-qAAbR1G748+2vwwfAhpe8luVEIKNGifqXqTV9QqaUFc=";
      name = "add_package_selection_command_line_arg.patch";
    })
    # Only consider (new) stable releases of NC apps
    # https://github.com/helsinki-systems/nc4nix/issues/4
    (fetchpatch {
      url = "https://github.com/helsinki-systems/nc4nix/pull/5/commits/076a188bf30203ddea0217d83f2e3b16f3b9392b.patch";
      sha256 = "sha256-N7X9j0tWD8ZAWjXXCXGITl/EBbrIbKbHJHyskT1rVTs=";
      name = "only_consider_stable_releases.patch";
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

