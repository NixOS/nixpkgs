{ lib, fetchgit, buildGoModule }:

buildGoModule rec {
  pname = "obfs4";
  version = "0.0.12";

  src = fetchgit {
    url = "https://git.torproject.org/pluggable-transports/obfs4.git";
    rev = "a564bc3840bc788605e1a8155f4b95ce0d70c6db"; # not tagged
    sha256 = "0hqk540q94sh4wvm31jjcvpdklhf8r35in4yii7xnfn58a7amfkc";
  };

  vendorSha256 = "0yjanv5piygffpdfysviijl7cql2k0r05bsxnlj4hbamsriz9xqy";

  meta = with lib; {
    description = "A pluggable transport proxy";
    homepage = "https://www.torproject.org/projects/obfsproxy";
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "obfs4proxy";
  };
}
