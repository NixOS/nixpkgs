{ pkgs, ... }:

with pkgs;

{
  nodes = {
    one =
      { config, pkgs, ... }: {
        services.avahi.enable = true;
        services.avahi.nssmdns = true;
      };

    two =
      { config, pkgs, ... }: {
        services.avahi.enable = true;
        services.avahi.nssmdns = true;
      };
  };

  # Test whether `avahi-daemon' and `libnss-mdns' work as expected.
  testScript =
    '' startAll;

       # mDNS.
       print STDERR
        $one->mustSucceed("avahi-resolve-host-name one.local | tee out");
       $one->mustSucceed("test \"`cut -f1 < out`\" = one.local");
       print STDERR
        $one->mustSucceed("avahi-resolve-host-name two.local | tee out");
       $one->mustSucceed("test \"`cut -f1 < out`\" = two.local");

       print STDERR
        $two->mustSucceed("avahi-resolve-host-name one.local | tee out");
       $two->mustSucceed("test \"`cut -f1 < out`\" = one.local");
       print STDERR
        $two->mustSucceed("avahi-resolve-host-name two.local | tee out");
       $two->mustSucceed("test \"`cut -f1 < out`\" = two.local");

       # Basic DNS-SD.
       print STDERR
        $one->mustSucceed("avahi-browse -r -t _workstation._tcp | tee out");
       $one->mustSucceed("test `wc -l < out` -gt 0");
       print STDERR
        $two->mustSucceed("avahi-browse -r -t _workstation._tcp | tee out");
       $two->mustSucceed("test `wc -l < out` -gt 0");

       # More DNS-SD.
       $one->execute("avahi-publish -s \"This is a test\" _test._tcp 123 one=1 &");
       sleep 5;
       print STDERR
        $two->mustSucceed("avahi-browse -r -t _test._tcp | tee out");
       $two->mustSucceed("test `wc -l < out` -gt 0");

       # NSS-mDNS.
       print STDERR $one->mustSucceed("ping -c1 one.local");
       print STDERR $one->mustSucceed("ping -c1 two.local");
       print STDERR $two->mustSucceed("ping -c1 one.local");
       print STDERR $two->mustSucceed("ping -c1 two.local");
    '';
}
