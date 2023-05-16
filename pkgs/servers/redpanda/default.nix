{ lib
, stdenv
, fetchzip
}:

let

  arch = if stdenv.isAarch64 then "arm" else "amd";
  sha256s = {
    amd = "sha256-V96Ro1MFkTXb6WPY3/61W8Ksdb72TX/Fcfs9s+cKs4k=";
    arm = "";  # TODO: Figure out this
  };

in stdenv.mkDerivation rec {
  pname = "redpandabin";
  version = "23.1.2";

  src = fetchzip {  # TODO: Should we use github release instead?
    url = "https://dl.redpanda.com/nzc4ZYQK3WRGd9sy/redpanda/raw/names/redpanda-${arch}64/versions/${version}/redpanda-${version}-${arch}64.tar.gz";
    sha256 = sha256s.${arch};
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec
    cp -R lib $out
    cp \
      bin/hwloc-calc-redpanda bin/hwloc-distrib-redpanda \
      bin/iotune-redpanda bin/redpanda bin/rpk \
      $out/bin
    cp \
      libexec/hwloc-calc-redpanda  libexec/hwloc-distrib-redpanda  \
      libexec/iotune-redpanda  libexec/redpanda  libexec/rpk \
      $out/libexec
    cp -R RELEASE-DATE.txt $out

    runHook postInstall
  '';

  meta = with lib; {
    # TODO: Fill out meta
    platforms = platforms.linux;
  };

}
