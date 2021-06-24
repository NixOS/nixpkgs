{ lib
, stdenv
, autoPatchelfHook
, fetchurl
, file
, makeWrapper
, ncurses
, nixosTests
, openssl
, unzip
, zlib
}:
stdenv.mkDerivation {
  pname = "pleroma-otp";
  version = "2.3.0";

  # To find the latest binary release stable link, have a look at
  # the CI pipeline for the latest commit of the stable branch
  # https://git.pleroma.social/pleroma/pleroma/-/tree/stable
  src = {
    aarch64-linux = fetchurl {
      url = "https://git.pleroma.social/pleroma/pleroma/-/jobs/182392/artifacts/download";
      sha256 = "1drpd6xh7m2damxi5impb8jwvjl6m3qv5yxynl12i8g66vi3rbwf";
    };
    x86_64-linux = fetchurl {
      url = "https://git.pleroma.social/pleroma/pleroma/-/jobs/182388/artifacts/download";
      sha256 = "0glr0iiqmylwwsn5r946yqr9kx97j2zznrc0imyxm3j0vhz8xzl4";
    };
  }."${stdenv.hostPlatform.system}";

  nativeBuildInputs = [ unzip ];

  buildInputs = [
    autoPatchelfHook
    file
    makeWrapper
    ncurses
    openssl
    zlib
  ];

  # mkDerivation fails to detect the zip nature of $src due to the
  # missing .zip extension.
  # Let's unpack the archive explicitely.
  unpackCmd = "unzip $curSrc";

  installPhase = ''
    mkdir $out
    cp -r * $out'';

  # Pleroma is using the project's root path (here the store path)
  # as its TMPDIR.
  # Patching it to move the tmp dir to the actual tmpdir
  postFixup = ''
    wrapProgram $out/bin/pleroma \
      --set-default RELEASE_TMP "/tmp"
    wrapProgram $out/bin/pleroma_ctl \
      --set-default RELEASE_TMP "/tmp"'';

  passthru.tests = {
    pleroma = nixosTests.pleroma;
  };

  meta = with lib; {
    description = "ActivityPub microblogging server";
    homepage = https://git.pleroma.social/pleroma/pleroma;
    license = licenses.agpl3;
    maintainers = with maintainers; [ ninjatrappeur ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
