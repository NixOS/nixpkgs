{ lib, stdenv, fetchFromGitLab, pkg-config, libbsd, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "netcat-openbsd";
  version = "1.219-1";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "netcat-openbsd";
    rev = "refs/tags/debian/${version}";
    sha256 = "sha256-rN8pl3Qf0T8bXGtVH22tBpGY/EcnbgGm1G8Z2patGbo=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ libbsd ];

  postPatch = ''
    for file in $(cat debian/patches/series); do
      patch -p1 < debian/patches/$file
    done
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv nc $out/bin/nc
    installManPage nc.1

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/nc -h 2> /dev/null
  '';

  meta = with lib; {
    description = "TCP/IP swiss army knife. OpenBSD variant";
    homepage = "https://salsa.debian.org/debian/netcat-openbsd";
    maintainers = with maintainers; [ artturin ];
    license = licenses.bsd3;
    platforms = platforms.unix;
    mainProgram = "nc";
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin;
  };
}
