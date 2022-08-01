{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "hysteria";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "HyNetwork";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-V+umf7+qRANSNsMrU1Vij3ni6ayq/d41xSy3o+7sEHQ=";
  };

  vendorSha256 = "sha256-oxCZ4+E3kffHr8ca9BKCSYcSWQ8jwpzrFs0fvCvZyJE=";
  proxyVendor = true;

  doCheck = false;
  #  postPatch = ''
  #    # rm test
  #    rm pkg/acl/engine_test.go
  #    rm pkg/acl/entry_test.go
  #  '';
  
  meta = with lib; {
    description = ''
      Hysteria is a feature-packed proxy & relay
      utility optimized for lossy, unstable connections
      powered by a customized QUIC protocol
    '';
    homepage = "https://github.com/HyNetwork/hysteria";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oluceps ];
  };
}
