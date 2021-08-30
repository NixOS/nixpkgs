{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "oauth2l";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-HOUy+F4WCZE9NA9Z9uIENTOTv+F9iHQmeNIvH8YCPSk=";
  };

  vendorSha256 = null;

  # the test suite's use of runtime.Caller(0) to find relative file paths is incompatible with -trimpath
  allowGoReference = true;

  # as it's a utility that drops files in your homedir, it needs writable home.
  preCheck = ''
    # failed to read configuration:  mkdir /homeless-shelter: permission denied
    export HOME=$TMPDIR
  '';

  meta = {
    description = "A tool for working with Google OAuth 2.0";
    homepage = "https://github.com/google/oauth2l";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pjjw ];
    platforms = lib.platforms.unix;
  };
}
