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
  version = "2.2.2";

  # To find the latest binary release stable link, have a look at
  # the CI pipeline for the latest commit of the stable branch
  # https://git.pleroma.social/pleroma/pleroma/-/tree/stable
  src = {
    aarch64-linux = fetchurl {
      url = "https://git.pleroma.social/pleroma/pleroma/-/jobs/175288/artifacts/download";
      sha256 = "107kp5zqwq1lixk1cwkx4v7zpm0h248xzlm152aj36ghb43j2snw";
    };
    x86_64-linux = fetchurl {
      url = "https://git.pleroma.social/pleroma/pleroma/-/jobs/175284/artifacts/download";
      sha256 = "1c6l04gga9iigm249ywwcrjg6wzy8iiid652mws3j9dnl71w2sim";
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
