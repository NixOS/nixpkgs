{ stdenv
, lib
, fetchFromSourcehut
, gitUpdater
, hare
, hareThirdParty
}:

stdenv.mkDerivation rec {
  pname = "bonsai";
  version = "1.0.2";

  src = fetchFromSourcehut {
    owner = "~stacyharper";
    repo = "bonsai";
    rev = "v${version}";
    hash = "sha256-Yosf07KUOQv4O5111tLGgI270g0KVGwzdTPtPOsTcP8=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'hare build' 'hare build $(HARE_TARGET_FLAGS)'
  '';

  nativeBuildInputs = [
    hare
  ];

  buildInputs = with hareThirdParty; [
    hare-ev
    hare-json
  ];

  env.HARE_TARGET_FLAGS =
    if stdenv.hostPlatform.isAarch64 then
      "-a aarch64"
    else if stdenv.hostPlatform.isRiscV64 then
      "-a riscv64"
    else if stdenv.hostPlatform.isx86_64 then
      "-a x86_64"
    else
      "";
  # TODO: hare setup-hook is supposed to do this for us.
  # It does it correctly for native compilation, but not cross compilation: wrong offset?
  env.HAREPATH = with hareThirdParty; "${hare-json}/src/hare/third-party:${hare-ev}/src/hare/third-party";

  preConfigure = ''
    export HARECACHE=$(mktemp -d)
  '';

  installFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Finite State Machine structured as a tree";
    homepage = "https://git.sr.ht/~stacyharper/bonsai";
    license = licenses.agpl3;
    maintainers = with maintainers; [ colinsane ];
    platforms = platforms.linux;
  };
}
