{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "hishtory";
  version = "0.208";

  src = fetchFromGitHub {
    owner = "ddworken";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TEto5lLH5nwqJ9PaYKrYCNW4/zrIICANQlGmqwDbOm4=";
  };

  vendorHash = "sha256-FodgIELV5JbqP3h/mIDDYARZcols9ZEtVREW1853EOI=";

  ldflags = [ "-X github.com/ddworken/hishtory/client/lib.Version=${version}" ];

  excludedPackages = [ "backend/server" ];

  postInstall = ''
    mkdir -p $out/share/hishtory
    cp client/lib/config.* $out/share/hishtory
  '';

  doCheck = false;

  meta = with lib; {
    description = "Your shell history: synced, queryable, and in context";
    homepage = "https://github.com/ddworken/hishtory";
    license = licenses.mit;
    maintainers = with maintainers; [ Enzime ];
  };
}

