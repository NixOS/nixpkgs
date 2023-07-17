{ buildGoModule
, fetchFromGitHub
, lib, stdenv
}:

buildGoModule rec {
  pname = "monsoon";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = "monsoon";
    rev = "v${version}";
    sha256 = "sha256-7cfy8dYhiReFVz10wui3qqxlXOX7wheREkvSnj2KyOw=";
  };

  vendorHash = "sha256-SZDX61iPwT/mfxJ+n2nlvzgEvUu6h3wVkmeqZtxQ9KE=";

  # tests fails on darwin
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Fast HTTP enumerator";
    longDescription = ''
      A fast HTTP enumerator that allows you to execute a large number of HTTP
      requests, filter the responses and display them in real-time.
    '';
    homepage = "https://github.com/RedTeamPentesting/monsoon";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
