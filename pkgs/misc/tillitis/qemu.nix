{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, qemu
, git
, buildPackages
}:

(qemu.override { enableDocs = false; })
  .overrideAttrs(previousAttrs: {
  version = "7.2.1";

  # This is just `git rebase` of the tillitis fork forward to
  # upstream v7.2.1, with a few very small and very obvious merge
  # conflicts fixed.
  #
  # An official rebase from tillits has been requested:
  # https://github.com/tillitis/qemu/issues/13
  #
  src = fetchFromGitHub {
    owner = "amjoseph-nixpkgs";
    repo = "qemu";
    rev = "e17b37e28046c7ca089db90dd3fa168cc0c02fce";
    hash = "sha256-hQcEHU9dS5Z0z9YjUJdXJfkm42U3SXF4n0DcEleIeac=";
    fetchSubmodules = true;
  };

  naiveBuildInputs = previousAttrs.nativeBuildInputs ++ [
    git
  ];

  configureFlags = previousAttrs.configureFlags ++ [
    "--with-git=${buildPackages.git}/bin/git"

    # https://github.com/tillitis/tillitis-key1-apps#running-device-apps-in-qemu
    "--target-list=riscv32-softmmu"

    # https://github.com/tillitis/qemu/issues/3
    "--disable-werror"
  ];

  NIX_CFLAGS_COMPILE = (previousAttrs.NIX_CFLAGS_COMPILE or "") + "-Wno-error=discarded-qualifiers";

  meta = previousAttrs.meta // {
    description = previousAttrs.meta.description + "(tillitis fork)";
    homepage = "https://github.com/tillitis/qemu/";
  };
})
