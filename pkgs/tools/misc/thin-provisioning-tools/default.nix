{ lib
, rustPlatform
, fetchFromGitHub
, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "thin-provisioning-tools";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "jthornber";
    repo = "thin-provisioning-tools";
    rev = "v${version}";
    hash = "sha256-wliyTWo3iOonqf4UW50V5co0RQlc75VwLofF9FHV2LI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rio-0.9.4" = "sha256-2l5cm7YLZyf2kuRPMytu7Fdewi6x3+9KyyQBv2F8ZDA=";
    };
  };

  passthru.tests = {
    inherit (nixosTests.lvm2) lvm-thinpool-linux-latest;
  };

  # required for config compatibility with configs done pre 0.9.0
  # see https://github.com/NixOS/nixpkgs/issues/317018
  postInstall = ''
    ln -s $out/bin/pdata_tools $out/bin/cache_check
    ln -s $out/bin/pdata_tools $out/bin/cache_dump
    ln -s $out/bin/pdata_tools $out/bin/cache_metadata_size
    ln -s $out/bin/pdata_tools $out/bin/cache_repair
    ln -s $out/bin/pdata_tools $out/bin/cache_restore
    ln -s $out/bin/pdata_tools $out/bin/cache_writeback
    ln -s $out/bin/pdata_tools $out/bin/era_check
    ln -s $out/bin/pdata_tools $out/bin/era_dump
    ln -s $out/bin/pdata_tools $out/bin/era_invalidate
    ln -s $out/bin/pdata_tools $out/bin/era_restore
    ln -s $out/bin/pdata_tools $out/bin/thin_check
    ln -s $out/bin/pdata_tools $out/bin/thin_delta
    ln -s $out/bin/pdata_tools $out/bin/thin_dump
    ln -s $out/bin/pdata_tools $out/bin/thin_ls
    ln -s $out/bin/pdata_tools $out/bin/thin_metadata_size
    ln -s $out/bin/pdata_tools $out/bin/thin_repair
    ln -s $out/bin/pdata_tools $out/bin/thin_restore
    ln -s $out/bin/pdata_tools $out/bin/thin_rmap
    ln -s $out/bin/pdata_tools $out/bin/thin_trim
  '';

  meta = with lib; {
    homepage = "https://github.com/jthornber/thin-provisioning-tools/";
    description = "Suite of tools for manipulating the metadata of the dm-thin device-mapper target";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
