# shellcheck shell=bash

setupModuleCompressionHook() {
  # Ensure CRC32 is used, which the kernel is capable of decompressing natively (enabled by CONFIG_MODULE_DECOMPRESS=y).
  export XZ_OPT="--check=crc32"
}

if [[ -z "${dontSetupModuleCompression-}" ]]; then
  nixInfoLog "Using setupModuleCompressionHook"
  postConfigureHooks+=(setupModuleCompressionHook)
fi
