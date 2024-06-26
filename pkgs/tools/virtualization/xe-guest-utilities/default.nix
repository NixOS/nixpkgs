{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runtimeShell,
}:

buildGoModule rec {
  pname = "xe-guest-utilities";
  version = "8.4.0";

  src = fetchFromGitHub {
    owner = "xenserver";
    repo = "xe-guest-utilities";
    rev = "v${version}";
    hash = "sha256-LpZx+Km2qRywYK/eFLP3aCDku6K6HC4+MzEODH+8Gvs=";
  };

  deleteVendor = true;
  vendorHash = "sha256-X/BI+ZhoqCGCmJfccyEBVgZc70aRTp3rL5j+rBWG5fE=";

  postPatch = ''
    substituteInPlace mk/xen-vcpu-hotplug.rules \
      --replace "/bin/sh" "${runtimeShell}"
  '';

  buildPhase = ''
    runHook preBuild

    make RELEASE=nixpkgs

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dt "$out"/bin build/stage/usr/{,s}bin/*
    install -Dt "$out"/etc/udev/rules.d build/stage/etc/udev/rules.d/*

    runHook postInstall
  '';

  meta = {
    description = "XenServer guest utilities";
    homepage = "https://github.com/xenserver/xe-guest-utilities";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
