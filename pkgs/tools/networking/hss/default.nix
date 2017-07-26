{ lib, buildRubyGem, ruby, openssh }:

# Example ~/.hss.yml
#---
#patterns:
#  - note: Basic test
#    example: g -> github
#    short: '^g$'
#    long: 'git@github.com'

buildRubyGem rec {
  name = "hss-${version}";
  inherit ruby;
  gemName = "hss";
  version = "1.0.1";
  sha256 = "0hdfpxxqsh6gisn8mm0knsl1aig9fir0h2x9sirk3gr36qbz5xa4";

  postInstall = ''
   substituteInPlace $GEM_HOME/gems/${gemName}-${version}/bin/hss \
     --replace \
       "'ssh'" \
       "'${openssh}/bin/ssh'"
  '';

  meta = with lib; {
    description = ''
      A SSH helper that uses regex and fancy expansion to dynamically manage SSH shortcuts.
    '';
    homepage    = https://github.com/akerl/hss;
    license     = licenses.mit;
    maintainers = with maintainers; [ nixy ];
    platforms   = platforms.unix;
  };
}
