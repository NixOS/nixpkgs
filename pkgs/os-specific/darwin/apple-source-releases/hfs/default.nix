{
  appleDerivation',
  stdenv,
  stdenvNoCC,
  lib,
  headersOnly ? true,
}:

appleDerivation' (if headersOnly then stdenvNoCC else stdenv) {
  installPhase = lib.optionalString headersOnly ''
    mkdir -p $out/include/hfs
    cp core/*.h $out/include/hfs
  '';

  appleHeaders = ''
    hfs/BTreeScanner.h
    hfs/BTreesInternal.h
    hfs/BTreesPrivate.h
    hfs/CatalogPrivate.h
    hfs/FileMgrInternal.h
    hfs/HFSUnicodeWrappers.h
    hfs/UCStringCompareData.h
    hfs/hfs.h
    hfs/hfs_alloc_trace.h
    hfs/hfs_attrlist.h
    hfs/hfs_btreeio.h
    hfs/hfs_catalog.h
    hfs/hfs_cnode.h
    hfs/hfs_cprotect.h
    hfs/hfs_dbg.h
    hfs/hfs_endian.h
    hfs/hfs_extents.h
    hfs/hfs_format.h
    hfs/hfs_fsctl.h
    hfs/hfs_hotfiles.h
    hfs/hfs_iokit.h
    hfs/hfs_journal.h
    hfs/hfs_kdebug.h
    hfs/hfs_key_roll.h
    hfs/hfs_macos_defs.h
    hfs/hfs_mount.h
    hfs/hfs_quota.h
    hfs/hfs_unistr.h
    hfs/kext-config.h
    hfs/rangelist.h
  '';

  meta = {
    # Seems nobody wants its binary, so we didn't implement building.
    broken = !headersOnly;
    platforms = lib.platforms.darwin;
  };
}
