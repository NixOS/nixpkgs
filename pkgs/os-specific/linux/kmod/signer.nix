{
  stdenv,
  lib,
  kmod,
  xz,
  zstd,
  gzip,
  name ? "kernel-modules-signed",
  modules,
  module-signing,
  pubKeyPath,
  privKeyPathOrUri,
  hashAlgorithm,
}:

stdenv.mkDerivation rec {
  inherit name;

  dontUnpack = true;

  nativeBuildInputs = [ gzip xz zstd ];

  # this is based on aggregator, but has to make changes and therefore copies
  # instead of symlinks
  buildPhase = ''
    if ! test -d "${modules}/lib/modules"; then
      echo "No modules found."
      # To support a kernel without modules
      exit 0
    fi

    kernelVersion=$(cd ${modules}/lib/modules && ls -d *)
    if test "$(echo $kernelVersion | wc -w)" != 1; then
       echo "inconsistent kernel versions: $kernelVersion"
       exit 1
    fi

    echo "kernel version is $kernelVersion"

    cp -Lr ${modules}/* .

    # need to make modules writeable for signing, remove again later
    chmod +w lib -R

    shopt -s extglob

    # adapt this to new compression schemes, when needed
    # types of modules (as of kernel 6.14):
    #   - uncompressed (.ko)
    #   - compressed with gzip (.ko.gz)
    #   - compressed with xz (.ko.xz)
    #   - compressed with zstd (.ko.zst)
    #
    # This can be rather slow for default kernels,
    # as they have many modules and signing happens
    # sequentially.
    # But it seems to be tolerable for the typical
    # customized kernel, which probably mostly
    # gets in touch with this.
    #
    for mod in `find . -name "*.ko.*"`; do
      mod_filename=`basename "$mod"`
      mod_filename_ko=$mod_filename
      # get potential compression type
      mod_filetype=`echo $mod_filename | sed 's/^.*\.//'`
      # strip compression type
      if [ "$mod_filetype" != "ko" ]; then
        mod_filename_ko=`echo $mod_filename | sed 's/\.[^.]*$//'`
      fi
      mod_dir=`dirname "$mod"`
      
      pushd "$mod_dir" > /dev/null

      chmod +w "$mod_filename"

      echo "signing $mod_filename"

      # may decompress
      case "$mod_filetype" in
        xz) xz -d "$mod_filename" ;;
        gz) gzip -d "$mod_filename" ;;
        zst) zstd --rm -d "$mod_filename" ;;
      esac

      # sign
      ${module-signing}/bin/sign-file "${hashAlgorithm}" \
        "${privKeyPathOrUri}" \
        "${pubKeyPath}" \
        "$mod_filename_ko"

      # compress, sync with "scripts/Makefile.modinst" in kernel
      case "$mod_filetype" in
        xz) xz --check=crc32 --lzma2=dict=1MiB -f "$mod_filename_ko" ;;
        gz) gzip -n -f "$mod_filename_ko" ;;
        zst) zstd -T0 --rm -f -q "$mod_filename_ko" ;;
      esac

      chmod -w "$mod_filename"

      popd > /dev/null
    done

    # needed to make modules writeable for signing, remove again here
    chmod -w lib -R
  '';

  installPhase = ''
    mkdir -p $out
    cp -Lr * $out/
  '';
}