{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0irbdwkkjwzajq1ip6ba46q49sxnrl2cw7ddkdhsfhb6aprnm3vr";
      type = "gem";
    };
    version = "2.8.6";
  };
  faraday = {
    dependencies = [ "faraday-net_http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qqb1rmk0f9m82iijjlqadh5yby1bhnr6svjk9vxdvh6f181988s";
      type = "gem";
    };
    version = "2.9.0";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17w51yk4rrm9rpnbc3x509s619kba0jga3qrj4b17l30950vw9qn";
      type = "gem";
    };
    version = "3.1.0";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10n2n9aq00ih8v881af88l1zyrqgs5cl3njdw8argjwbl5ggqvm9";
      type = "gem";
    };
    version = "0.4.1";
  };
  octokit = {
    dependencies = [
      "faraday"
      "sawyer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15g4kyag6gmxxq6d03472h7srm3imlsks1wg6nac7hl3mb1b5vs8";
      type = "gem";
    };
    version = "5.6.1";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14y4vzjwf5gp0mqgs880kis0k7n2biq8i6ci6q2n315kichl1hvj";
      type = "gem";
    };
    version = "5.0.5";
  };
  sawyer = {
    dependencies = [
      "addressable"
      "faraday"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jks1qjbmqm8f9kvwa81vqj39avaj9wdnzc531xm29a55bb74fps";
      type = "gem";
    };
    version = "0.9.2";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "094gk72ckazf495qc76gk09b5i318d5l9m7bicg2wxlrjcm3qm96";
      type = "gem";
    };
    version = "0.13.0";
  };
}
