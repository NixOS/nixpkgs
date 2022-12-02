{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "norouter";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "norouter";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h5jzxm4fw50781zj76r5ksnxkzsnrygrykpa913v9nd24c09c7m";
  };

  vendorSha256 = "sha256-DZ2kcNV8AzNogAUTaeus4rz9gCFo0wm306jcz/cAj0M=";

  subPackages = [ "cmd/norouter" ];
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/norouter --version | grep ${version} > /dev/null

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Tool to handle unprivileged networking by using multiple loopback addresses";
    homepage = "https://github.com/norouter/norouter";
    license = licenses.asl20;
    maintainers = with maintainers; [ blaggacao ];
  };
}
