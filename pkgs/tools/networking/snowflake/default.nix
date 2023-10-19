{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "snowflake";
  version = "2.6.1";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${version}";
    sha256 = "sha256-3gLcSZv8GpEio+yvPyBVVceb1nO0HzhpQKhEgf4nQvU=";
  };

  vendorHash = "sha256-MjxDB9fcPM6nIeGk6YvJOKXI/ThlMrxqJl9ROAREwXk=";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/raw/v${version}/ChangeLog";
    maintainers = with maintainers; [ lourkeur yayayayaka ];
    license = licenses.bsd3;
  };
}
