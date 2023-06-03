{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  version = "1.3.0";
  pname = "mmdbctl";

  src = fetchFromGitHub {
    rev = "${pname}-${version}";
    owner = "ipinfo";
    repo = pname;
    hash = "sha256-YRmOb6D8DX4ctV8vg7wmjZhjymoEVjsQlhPKeSPED/M=";
  };

  vendorHash = "sha256-nP+1qav+afqBOveMiUApE3hfjNHf6iVF3Ov2e80ho0g=";

  meta = with lib; {
    homepage = "https://github.com/ipinfo/mmdbctl";
    description = "An MMDB file management CLI supporting various operations on MMDB database files";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ linsui ];
    platforms = platforms.unix;
  };
}
