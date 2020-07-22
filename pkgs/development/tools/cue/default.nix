{ buildGoModule, fetchgit, stdenv }:

buildGoModule rec {
  pname = "cue";
  version = "0.2.2";

  src = fetchgit {
    url = "https://cue.googlesource.com/cue";
    rev = "v${version}";
    sha256 = "1crl5fldczc3jkwf7gvwvghckr6gfinfslzca4ps1098lbq83zcq";
  };

  vendorSha256 = "0l6slaji9nh16jqp1nvib95h2db1xyjh6knk5hj2zaa1rks4b092";

  subPackages = [ "cmd/cue" ];

  buildFlagsArray = [
    "-ldflags=-X cuelang.org/go/cmd/cue/cmd.version=${version}"
  ];

  meta = {
    description = "A data constraint language which aims to simplify tasks involving defining and using data";
    homepage = "https://cuelang.org/";
    maintainers = with stdenv.lib.maintainers; [ solson ];
    license = stdenv.lib.licenses.asl20;
  };
}
