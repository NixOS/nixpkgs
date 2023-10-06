{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "upspin";
  version = "unstable-2023-02-05";

  src = fetchFromGitHub {
    owner = "upspin";
    repo = "upspin";
    rev = "67e250ec27d8878c0009213b8e32c6803f2727ea";
    sha256 = "sha256-1pFDJSCUDKn4CTAg3wdB8oYPyrmd8B62zNl3m5YAqVM=";
  };

  vendorHash = "sha256-Jl++FvKyqz5WFa/Eoly+UnFsoC9Qwdaizhkq6LyJ+XQ=";

  # No upstream tests
  doCheck = false;

  meta = with lib; {
    description = "A global name space for storing data akin to a filesystem";
    homepage = "https://upspin.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ orthros ];
    platforms = platforms.linux;
  };
}
