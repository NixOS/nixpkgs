{ buildGoModule
, fetchFromGitHub
, lib
, runCommand
, ran
, curl
}:

buildGoModule rec {
  pname = "ran";
  version = "0.1.6";
  src = fetchFromGitHub {
    owner = "m3ng9i";
    repo = "ran";
    rev = "v${version}";
    hash = "sha256-iMvUvzr/jaTNdgHQFuoJNJnnkx2XHIUUlrPWyTlreEw=";
  };

  vendorHash = "sha256-ObroruWWNilHIclqNvbEaa7vwk+1zMzDKbjlVs7Fito=";

  CGO_ENABLED = 0;

  ldflags = [
    "-X" "main._version_=v${version}"
    "-X" "main._branch_=master"
  ];

  passthru.tests = {
    simple = runCommand "ran-test" { } ''
      echo hello world > index.html
      ${ran}/bin/ran &
      # Allow ran to fully initialize
      sleep 1
      [ "$(${curl}/bin/curl 127.0.0.1:8080)" == "hello world" ]
      kill %1
      ${ran}/bin/ran --version > $out
    '';
  };

  meta = with lib; {
    homepage = "https://github.com/m3ng9i/ran";
    description = "Ran is a simple web server for serving static files";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
  };
}
