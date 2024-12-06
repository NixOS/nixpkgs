{ lib, stdenv, fetchFromGitLab, fetchpatch, rustPlatform, pkg-config, openssl
, installShellFiles
, Security, AppKit

, x11Support ? stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isBSD
, xclip ? null, xsel ? null
, preferXsel ? false # if true and xsel is non-null, use it instead of xclip
}:

let
  usesX11 = stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isBSD;
in

assert (x11Support && usesX11) -> xclip != null || xsel != null;

rustPlatform.buildRustPackage rec {
  pname = "ffsend";
  version = "0.2.76";

  src = fetchFromGitLab {
    owner = "timvisee";
    repo = "ffsend";
    rev = "v${version}";
    hash = "sha256-L1j1lXPxy9nWMeED9uzQHV5y7XTE6+DB57rDnXa4kMo=";
  };

  cargoHash = "sha256-r1yIPV2sW/EpHJpdaJyi6pzE+rtNkBIxSUJF+XA8kbA=";

  cargoPatches = [

    # Update dependencies (needed for the below patch to merge cleanly)
    (fetchpatch {
      name = "Update-dependencies-1";
      url = "https://github.com/timvisee/ffsend/commit/afb004680b9ed672c7e87ff23f16bb2c51fea06e.patch";
      hash = "sha256-eDcbyi05aOq+muVWdLmlLzLXUKcrv/9Y0R+0aHgL4+s=";
    })

    # Disable unused features in prettytable-rs crate (needed for the below patch to merge cleanly)
    (fetchpatch {
      name = "Disable-unused-features";
      url = "https://github.com/timvisee/ffsend/commit/9b8dee12ea839f911ed207ff9602d929cab5d34b.patch";
      hash = "sha256-6LK1Fqov+zEbPZ4+B6JCLXtXmgSad9vr9YO2oYodBSM=";
    })

    # Update dependencies (needed for the below patch to merge cleanly)
    (fetchpatch {
      name = "Update-dependencies-2";
      url = "https://github.com/timvisee/ffsend/commit/fd5b38f9ab9cbc5f962d1024f4809eb36ba8986c.patch";
      hash = "sha256-BDZKrVtQHpOewmB2Lb6kUfy02swcNK+CYZ3lj3kwFV4=";
    })

    # Fix seg fault
    (fetchpatch {
      name = "Fix-segfault";
      url = "https://github.com/timvisee/ffsend/commit/3c1c2dc28ca1d88c45f87496a7a96052f5c37858.patch";
      hash = "sha256-2hWlFXDopNy26Df74nJoB1J8qzPEOpf61wEOEtxOVx8=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs =
    if stdenv.hostPlatform.isDarwin then [ Security AppKit ]
    else [ openssl ];

  preBuild = lib.optionalString (x11Support && usesX11) (
    if preferXsel && xsel != null then ''
      export XSEL_PATH="${xsel}/bin/xsel"
    '' else ''
      export XCLIP_PATH="${xclip}/bin/xclip"
    ''
  );

  postInstall = ''
    installShellCompletion contrib/completions/ffsend.{bash,fish} --zsh contrib/completions/_ffsend
  '';
  # There's also .elv and .ps1 completion files but I don't know where to install those

  meta = with lib; {
    description = "Easily and securely share files from the command line. A fully featured Firefox Send client";
    longDescription = ''
      Easily and securely share files and directories from the command line through a safe, private
      and encrypted link using a single simple command. Files are shared using the Send service and
      may be up to 2GB. Others are able to download these files with this tool, or through their
      web browser.
    '';
    homepage = "https://gitlab.com/timvisee/ffsend";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
    mainProgram = "ffsend";
  };
}
