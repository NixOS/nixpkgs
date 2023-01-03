{ lib
, buildGoModule
, fetchFromGitHub
, runtimeShell
}:

buildGoModule rec {
  pname = "xe-guest-utilities";
  version = "7.30.0";

  src = fetchFromGitHub {
    owner = "xenserver";
    repo = "xe-guest-utilities";
    rev = "v${version}";
    hash = "sha256-gMb8QIUg8t0SiTtUzqeh4XM5hHgCXuf5KlV3OeoU0LI=";
  };

  vendorHash = "sha256-zhpDvo8iujE426/gxJY+Pqfv99vLNKHqyMQbbXIKodY=";

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
