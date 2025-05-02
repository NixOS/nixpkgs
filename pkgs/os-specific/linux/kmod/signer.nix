{
  stdenv,
  lib,
  kmod,
  xz,
  zstd,
  gzip,
  python3,
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

  nativeBuildInputs = [ python3 gzip xz zstd module-signing ];

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

    # don't leak env-vars to store
    mkdir -p signed-output
    pushd signed-output > /dev/null

    cp -Lr ${modules}/* .

    # need to make modules writeable for signing, remove again later
    chmod +w lib -R

    python3 ${./parallel_sign.py}              \
      --privKeyPathOrUri "${privKeyPathOrUri}" \
      --pubKeyPath "${pubKeyPath}"             \
      --hashAlgorithm "${hashAlgorithm}"       \
      --buildPath "$(pwd)"

    # needed to make modules writeable for signing, remove again here
    chmod -w lib -R

    # leave signed-output for following steps
    popd > /dev/null
  '';

  installPhase = ''
    mkdir -p $out
    pushd signed-output > /dev/null
    cp -Lr * $out/
    popd > /dev/null
  '';
}