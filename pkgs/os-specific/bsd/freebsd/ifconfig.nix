{ mkDerivation, lib, stdenv, compatIfNeeded, libifconfig, lib80211, libjail, libnv, ...}:
mkDerivation {
  path = "sbin/ifconfig";

  buildInputs = compatIfNeeded ++ [ libifconfig lib80211 libjail libnv ];

  # ifconfig believes libifconfig is internal and thus PIE.
  # We build libifconfig as an external library
  MK_PIE = "no";

  MK_TESTS = "no";
  preBuild = lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T -Dwchar_t=int -D_WCHAR_T_DECLARED"
  '';
}
