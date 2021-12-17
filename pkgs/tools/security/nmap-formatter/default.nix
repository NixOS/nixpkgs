{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nmap-formatter";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r8l7ajcb436b60ir6xgy53wafk6rw1cil326yg6mhcngz9sazbk";
  };

  vendorSha256 = "0c1b4iw28qj8iq55lg32xqw69jjdv5ial495j0gz68s17kydbwhb";

  postPatch = ''
    # Fix hard-coded release
    substituteInPlace cmd/root.go \
      --replace "0.2.0" "${version}"
  '';

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
