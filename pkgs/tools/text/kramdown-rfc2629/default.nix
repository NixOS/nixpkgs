{ lib, bundlerApp }:

# Not in the default ../../../development/ruby-modules/with-packages/Gemfile
# because of version clash on the "kramdown" dependency.
bundlerApp rec {
  pname = "kramdown-rfc2629";
  gemdir = ./.;
  exes = [ "kramdown-rfc2629" ];

  meta = with lib; {
    description = "A markdown parser with multiple backends";
    homepage    = "https://github.com/cabo/kramdown-rfc2629";
    license     = with licenses; mit;
    maintainers = with maintainers; [
      vcunat # not really, but I expect to use it occasionally around IETF
    ];
  };
}
