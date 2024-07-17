{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
}:

buildGoModule rec {
  pname = "age";
  version = "1.1.1";
  vendorHash = "sha256-MumPdRTz840+hoisJ7ADgBhyK3n8P6URobbRJYDFkDY=";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    rev = "v${version}";
    sha256 = "sha256-LRxxJQLQkzoCNYGS/XBixVmYXoZ1mPHKvFicPGXYLcw=";
  };

  # Worked with the upstream to change the way test vectors were sourced from
  # another repo at test run time, so we can run test without network access.
  # https://github.com/FiloSottile/age/pull/476
  #
  # Changes landed after v1.1.1, so we'll patch this one until next release.
  patches = [
    # Revert "all: temporarily disable testscript tests"
    (fetchpatch {
      name = "0001-revert-temporarily-disabled-testscript-tests.patch";
      url = "https://github.com/FiloSottile/age/commit/5471e05672de168766f5f11453fd324c53c264e5.patch";
      sha256 = "sha256-F3oDhRWJqqcF9MDDWPeO9V/wUGXkmUXY87wgokUIoOk=";
    })

    # age: depend on c2sp.org/CCTV/age for TestVectors
    (fetchpatch {
      name = "0002-depend-on-c2sp_cctv_age__TestVectors.patch";
      url = "https://github.com/FiloSottile/age/commit/edf7388f7731b274b055dcab3ec4006cc4961b68.patch";
      sha256 = "sha256-CloCj/uF3cqTeCfRkV6TeYiovuDQXm1ZIklREWAot1E=";
    })
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preInstall = ''
    installManPage doc/*.1
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    if [[ "$("$out/bin/${pname}" --version)" == "${version}" ]]; then
      echo '${pname} smoke check passed'
    else
      echo '${pname} smoke check failed'
      return 1
    fi
  '';

  # plugin test is flaky, see https://github.com/FiloSottile/age/issues/517
  checkFlags = [
    "-skip"
    "TestScript/plugin"
  ];

  meta = with lib; {
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    mainProgram = "age";
    maintainers = with maintainers; [ tazjin ];
  };
}
