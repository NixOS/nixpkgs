{ buildGoModule, fetchFromGitHub, lib }:

let
  version = "1.3.3";
  pname = "sdns";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "semihalev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U15EDIMGLk8fmWRSX37pHNuZV4DVY2NbUWbViHrpTHQ=";
  };

  vendorHash = "sha256-k6Co7T2/VI2QAfj9Ad7b+tloUSnMICQRm5p4ZctoF6A=";

  postPatch = ''
    substituteInPlace dnsutil/dnsutil_test.go \
      --replace "TestExchange" "SkipExchange"
    substituteInPlace middleware/cache/cache_test.go \
      --replace "Test_Cache_CNAME" "Skip_Cache_CNAME" \
      --replace "Test_Cache_ResponseWriter" "Skip_Cache_ResponseWriter"
    substituteInPlace middleware/failover/failover_test.go \
      --replace "Test_Failover" "Skip_Failover"
    substituteInPlace middleware/forwarder/forwarder_test.go \
      --replace "Test_Forwarder" "Skip_Forwarder"
    substituteInPlace middleware/resolver/client_test.go \
      --replace "Test_Client" "Skip_Client"
    substituteInPlace middleware/resolver/handler_test.go \
      --replace "Test_handler" "Skip_handler"
    substituteInPlace middleware/resolver/resolver_test.go \
      --replace "Test_resolver" "Skip_resolver"
    substituteInPlace server/doh/doh_test.go \
      --replace "Test_doh" "Skip_doh"
  '';

  meta = with lib; {
    description = "High-performance, recursive DNS resolver server with DNSSEC support, focused on preserving privacy.";
    homepage = "https://github.com/semihalev/sdns";
    license = licenses.mit;
    maintainers = with maintainers; [ abbe ];
  };
}
