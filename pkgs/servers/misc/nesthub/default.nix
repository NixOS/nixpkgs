{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "nesthub";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "yangl1996";
    repo = "nesthub";
    rev = "v${version}";
    sha256 = "013zk8r0zadwh40wdmagzgvsvbpj6yya31gg3fx2iw28slh40vrh";
  };

  vendorSha256 = "1hm97iyj7cwh7vckj3sv0q93wp1bxjj24bjkrzpphgas7v559dj9";

  meta = with lib; {
    description = "HomeKit bridge for Nest thermostats";
    homepage = "https://github.com/yangl1996/nesthub";
    license = licenses.mit;
    maintainers = with maintainers; [ nateinaction ];
  };
}

