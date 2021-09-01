{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxml2
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "hurl";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
    sha256 = "0hbyqj794pvvfrg6jgz63mih73bnmnvgmwbv705c2238w7wsgk9w";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxml2
    openssl
  ];

  # Tests require network access to a test server
  doCheck = false;

  cargoSha256 = "09ndgm6kmqwdz7yn2rqxk5xr1qkai87zm1k138cng4wq135c3w6g";

  meta = with lib; {
    description = "Command line tool that performs HTTP requests defined in a simple plain text format.";
    homepage = "https://hurl.dev/";
    maintainers = with maintainers; [ eonpatapon ];
    license = licenses.asl20;
  };
}
